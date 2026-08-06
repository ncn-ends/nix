#!/usr/bin/env python3
"""Log and browse iPhone notifications captured via ancs4linux.

The `log` subcommand subscribes to the `ancs4linux.Observer` D-Bus signal
`ShowNotification` (system bus) and appends every notification to a local
SQLite archive. The other subcommands read that archive so you can browse and
search your notification history, independent of desktop popups.
"""
import argparse
import json
import os
import shutil
import sqlite3
import subprocess
import sys
import time
from pathlib import Path


def db_path() -> Path:
    base = os.environ.get("XDG_DATA_HOME") or os.path.expanduser("~/.local/share")
    d = Path(base) / "ancs4linux"
    d.mkdir(parents=True, exist_ok=True)
    return d / "history.db"


def connect_db() -> sqlite3.Connection:
    con = sqlite3.connect(db_path())
    con.execute(
        """CREATE TABLE IF NOT EXISTS notifications (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ts INTEGER NOT NULL,
            device_name TEXT,
            app_id TEXT,
            app_name TEXT,
            notif_id INTEGER,
            title TEXT,
            body TEXT
        )"""
    )
    con.commit()
    return con


def cmd_log(args: argparse.Namespace) -> None:
    from dasbus.connection import SystemMessageBus
    from dasbus.loop import EventLoop

    con = connect_db()
    proxy = SystemMessageBus().get_proxy(args.service, "/")

    def on_show(payload: str) -> None:
        try:
            d = json.loads(payload)
        except Exception as e:  # noqa: BLE001
            print("skip bad payload:", e, file=sys.stderr)
            return
        con.execute(
            "INSERT INTO notifications"
            " (ts, device_name, app_id, app_name, notif_id, title, body)"
            " VALUES (?, ?, ?, ?, ?, ?, ?)",
            (
                int(time.time()),
                d.get("device_name"),
                d.get("app_id"),
                d.get("app_name"),
                d.get("id"),
                d.get("title"),
                d.get("body"),
            ),
        )
        con.commit()
        print(f"logged: [{d.get('app_name')}] {d.get('title')}", file=sys.stderr)

    proxy.ShowNotification.connect(on_show)
    print(f"Logging {args.service} -> {db_path()}", file=sys.stderr)
    EventLoop().run()


def query(con: sqlite3.Connection, where: str = "", params=(), limit: int = 100):
    sql = "SELECT id, ts, device_name, app_name, title, body FROM notifications"
    if where:
        sql += " WHERE " + where
    sql += " ORDER BY ts DESC LIMIT ?"
    return con.execute(sql, (*params, limit)).fetchall()


def fmt_line(row) -> str:
    _id, ts, _dev, app, title, body = row
    when = time.strftime("%Y-%m-%d %H:%M", time.localtime(ts))
    body1 = (body or "").replace("\n", " ")
    return f"{when}  [{app or '?'}] {title or ''} — {body1}"


def cmd_list(args: argparse.Namespace) -> None:
    con = connect_db()
    for row in reversed(query(con, limit=args.number)):
        print(fmt_line(row))


def cmd_search(args: argparse.Namespace) -> None:
    con = connect_db()
    like = f"%{args.query}%"
    rows = query(
        con,
        "app_name LIKE ? OR title LIKE ? OR body LIKE ?",
        (like, like, like),
        limit=args.number,
    )
    for row in reversed(rows):
        print(fmt_line(row))


def cmd_show(args: argparse.Namespace) -> None:
    con = connect_db()
    row = con.execute(
        "SELECT ts, device_name, app_name, title, body FROM notifications WHERE id=?",
        (args.id,),
    ).fetchone()
    if not row:
        sys.exit(1)
    ts, dev, app, title, body = row
    when = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(ts))
    print(f"{when}\nDevice: {dev}\nApp: {app}\n\n{title}\n\n{body or ''}")


def cmd_tui(args: argparse.Namespace) -> None:
    con = connect_db()
    rows = query(con, limit=args.number)
    if not shutil.which("fzf"):
        print("(fzf not found; falling back to plain list)\n", file=sys.stderr)
        for row in reversed(rows):
            print(fmt_line(row))
        return
    lines = [f"{row[0]}\t{fmt_line(row)}" for row in rows]
    subprocess.run(
        [
            "fzf",
            "--with-nth=2..",
            "--delimiter=\t",
            "--preview",
            f"{sys.argv[0]} show {{1}}",
            "--preview-window=down,55%,wrap",
            "--prompt=notifications> ",
        ],
        input="\n".join(lines),
        text=True,
        check=False,
    )


def main() -> None:
    p = argparse.ArgumentParser(
        prog="ancs4linux-history",
        description="Log and browse iPhone notifications from ancs4linux.",
    )
    sub = p.add_subparsers(dest="cmd", required=True)

    lg = sub.add_parser("log", help="Run the logging daemon.")
    lg.add_argument("--service", default="ancs4linux.Observer")
    lg.set_defaults(func=cmd_log)

    ls = sub.add_parser("list", help="List recent notifications.")
    ls.add_argument("-n", "--number", type=int, default=50)
    ls.set_defaults(func=cmd_list)

    se = sub.add_parser("search", help="Search app/title/body.")
    se.add_argument("query")
    se.add_argument("-n", "--number", type=int, default=200)
    se.set_defaults(func=cmd_search)

    sh = sub.add_parser("show", help="Show one notification by id.")
    sh.add_argument("id", type=int)
    sh.set_defaults(func=cmd_show)

    tu = sub.add_parser("tui", help="Interactive fuzzy browser (needs fzf).")
    tu.add_argument("-n", "--number", type=int, default=500)
    tu.set_defaults(func=cmd_tui)

    args = p.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
