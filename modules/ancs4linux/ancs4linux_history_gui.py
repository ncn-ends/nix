#!/usr/bin/env python3
"""A small GTK3 window to browse iPhone notifications archived by ancs4linux.

Reads the same SQLite database the `log` daemon writes and auto-refreshes, so
new notifications appear within a couple of seconds. Native GTK3 to fit the
Cinnamon desktop.
"""
import sqlite3
import sys
import time

import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GLib, Pango  # noqa: E402

from ancs4linux_history import connect_db, db_path  # noqa: E402


def esc(s: str) -> str:
    return GLib.markup_escape_text(s or "")


def fetch(needle: str = "", limit: int = 2000):
    connect_db().close()  # ensure the DB and table exist
    con = sqlite3.connect(f"file:{db_path()}?mode=ro", uri=True)
    sql = "SELECT id, ts, device_name, app_name, title, body FROM notifications"
    params: tuple = ()
    if needle:
        like = f"%{needle}%"
        sql += " WHERE app_name LIKE ? OR title LIKE ? OR body LIKE ?"
        params = (like, like, like)
    sql += " ORDER BY ts DESC LIMIT ?"
    rows = con.execute(sql, (*params, limit)).fetchall()
    con.close()
    return rows


def make_row(r) -> Gtk.ListBoxRow:
    _id, ts, _dev, app, title, body = r
    row = Gtk.ListBoxRow()
    box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=3)
    for m in ("set_margin_top", "set_margin_bottom"):
        getattr(box, m)(8)
    box.set_margin_start(12)
    box.set_margin_end(12)

    top = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
    head = Gtk.Label(xalign=0)
    head.set_markup(f"<b>{esc(app or '?')}</b>   {esc(title or '')}")
    head.set_ellipsize(Pango.EllipsizeMode.END)
    top.pack_start(head, True, True, 0)
    when = Gtk.Label(label=time.strftime("%b %-d  %H:%M", time.localtime(ts)))
    when.get_style_context().add_class("dim-label")
    top.pack_end(when, False, False, 0)
    box.pack_start(top, False, False, 0)

    if body:
        b = Gtk.Label(xalign=0, label=body)
        b.set_line_wrap(True)
        b.set_line_wrap_mode(Pango.WrapMode.WORD_CHAR)
        b.get_style_context().add_class("dim-label")
        box.pack_start(b, False, False, 0)

    row.add(box)
    return row


class HistoryWindow(Gtk.ApplicationWindow):
    def __init__(self, app):
        super().__init__(application=app)
        self.set_default_size(560, 660)
        self._sig = None  # (count, max_id, needle) to detect changes cheaply

        header = Gtk.HeaderBar(show_close_button=True)
        header.props.title = "iPhone Notifications"
        self.set_titlebar(header)

        self.search = Gtk.SearchEntry()
        self.search.set_placeholder_text("Search…")
        self.search.set_width_chars(28)
        self.search.connect("search-changed", lambda *_: self.reload(force=True))
        header.pack_start(self.search)

        refresh = Gtk.Button.new_from_icon_name("view-refresh-symbolic", Gtk.IconSize.BUTTON)
        refresh.set_tooltip_text("Refresh")
        refresh.connect("clicked", lambda *_: self.reload(force=True))
        header.pack_end(refresh)

        sw = Gtk.ScrolledWindow()
        sw.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        self.listbox = Gtk.ListBox()
        self.listbox.set_selection_mode(Gtk.SelectionMode.NONE)
        placeholder = Gtk.Label()
        placeholder.set_markup(
            "<big>No notifications yet</big>\n\n"
            "<span alpha='60%'>Lock your iPhone and trigger one.</span>"
        )
        placeholder.set_justify(Gtk.Justification.CENTER)
        placeholder.show_all()
        self.listbox.set_placeholder(placeholder)
        sw.add(self.listbox)
        self.add(sw)

        self.reload(force=True)
        GLib.timeout_add_seconds(2, self.reload)
        self.show_all()

    def reload(self, force: bool = False) -> bool:
        needle = self.search.get_text().strip()
        try:
            con = sqlite3.connect(f"file:{db_path()}?mode=ro", uri=True)
            cnt, maxid = con.execute(
                "SELECT count(*), coalesce(max(id), 0) FROM notifications"
            ).fetchone()
            con.close()
        except sqlite3.Error:
            cnt, maxid = 0, 0
        sig = (cnt, maxid, needle)
        if not force and sig == self._sig:
            return True
        self._sig = sig

        for child in self.listbox.get_children():
            self.listbox.remove(child)
        for r in fetch(needle):
            self.listbox.add(make_row(r))
        self.listbox.show_all()
        return True  # keep the GLib timer alive


def main() -> None:
    selftest = "--self-test" in sys.argv[1:]
    app = Gtk.Application(application_id="org.ancs4linux.History")

    def on_activate(a):
        HistoryWindow(a)
        if selftest:
            GLib.timeout_add(600, lambda: (print("self-test OK"), a.quit()) and False)

    app.connect("activate", on_activate)
    app.run([])


if __name__ == "__main__":
    main()
