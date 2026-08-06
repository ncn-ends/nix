# iPhone notifications on the desktop over Bluetooth LE (ANCS), plus a
# per-user logger that archives every notification to a browsable SQLite DB.
#
# Upstream: https://github.com/pzmarzly/ancs4linux (not in nixpkgs, so it is
# packaged inline here). The `ancs4linux-history` tool is local (see the
# ./ancs4linux directory) and lets you browse/search notifications:
#   ancs4linux-history list | search <text> | tui
{ imports, lib, ... }:
let
  stable = imports.stable;

  ancs4linux = stable.python3Packages.buildPythonApplication {
    pname = "ancs4linux";
    version = "unstable-2026-07-10";
    pyproject = true;

    src = stable.fetchFromGitHub {
      owner = "pzmarzly";
      repo = "ancs4linux";
      rev = "985b8d07681e41785fc589149fe520f8ba5d325c";
      hash = "sha256-Z998P9P7Yu055UwrRjA1uMTG/uJsH6MvlhzDURpG4dM=";
    };

    build-system = [ stable.python3Packages.hatchling ];
    # gobject-introspection + wrapGAppsHook3 expose the GLib/Gio typelibs to
    # PyGObject at runtime.
    nativeBuildInputs = [ stable.gobject-introspection stable.wrapGAppsHook3 ];
    buildInputs = [ stable.glib ];
    dependencies = with stable.python3Packages; [ dasbus pygobject3 typer ];

    doCheck = false;
    pythonImportsCheck = [ "ancs4linux" ];
  };

  ancs4linux-history = stable.python3Packages.buildPythonApplication {
    pname = "ancs4linux-history";
    version = "0.1.0";
    pyproject = true;
    src = ./ancs4linux;

    build-system = [ stable.python3Packages.hatchling ];
    nativeBuildInputs = [ stable.gobject-introspection stable.wrapGAppsHook3 ];
    buildInputs = [ stable.glib stable.gtk3 ];
    dependencies = with stable.python3Packages; [ dasbus pygobject3 ];
    # `tui` shells out to fzf.
    makeWrapperArgs = [ "--prefix" "PATH" ":" (lib.makeBinPath [ stable.fzf ]) ];

    # Desktop-menu entry for the GTK browser (ancs4linux-history-gui).
    postInstall = ''
      mkdir -p $out/share/applications
      cat > $out/share/applications/ancs4linux-history.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=iPhone Notifications
      Comment=Browse notifications from your iPhone
      Exec=ancs4linux-history-gui
      Icon=phone
      Terminal=false
      Categories=Utility;
      EOF
    '';

    doCheck = false;
    pythonImportsCheck = [ "ancs4linux_history" "ancs4linux_history_gui" ];
  };

  # System-bus D-Bus policy: root owns the service names; any local user may
  # talk to them (single-user desktop; avoids the supplementary-group login
  # requirement that context="default" sidesteps).
  policy = name: stable.writeText "ancs4linux-${name}.conf" ''
    <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
     "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
    <busconfig>
      <policy user="root">
        <allow own="ancs4linux.${name}"/>
      </policy>
      <policy context="default">
        <allow send_destination="ancs4linux.${name}"/>
        <allow receive_sender="ancs4linux.${name}"/>
      </policy>
    </busconfig>
  '';

  # NixOS manages /etc/dbus-1/system.d as a read-only tree, so policy files
  # must be delivered via services.dbus.packages (share/dbus-1/system.d).
  dbusPolicy = stable.runCommand "ancs4linux-dbus-policy" { } ''
    mkdir -p $out/share/dbus-1/system.d
    cp ${policy "Observer"} $out/share/dbus-1/system.d/ancs4linux-observer.conf
    cp ${policy "Advertising"} $out/share/dbus-1/system.d/ancs4linux-advertising.conf
  '';
in
{
  hardware.bluetooth.enable = lib.mkDefault true;
  # ANCS/GATT sometimes needs experimental BlueZ features; drop if unneeded.
  hardware.bluetooth.settings.General.Experimental = lib.mkDefault true;

  # jq is used by the pairing helper one-liner (ancs4linux-ctl get-all-hci | jq).
  environment.systemPackages = [ ancs4linux ancs4linux-history stable.jq ];

  services.dbus.packages = [ dbusPolicy ];

  # Daemons that touch the Bluetooth adapter run as root.
  systemd.services.ancs4linux-observer = {
    wantedBy = [ "multi-user.target" ];
    after = [ "bluetooth.service" ];
    serviceConfig.ExecStart = "${ancs4linux}/bin/ancs4linux-observer";
    serviceConfig.Restart = "on-failure";
  };
  systemd.services.ancs4linux-advertising = {
    wantedBy = [ "multi-user.target" ];
    after = [ "bluetooth.service" ];
    serviceConfig.ExecStart = "${ancs4linux}/bin/ancs4linux-advertising";
    serviceConfig.Restart = "on-failure";
  };

  # Shows notifications in the desktop session (Cinnamon's notification daemon).
  systemd.user.services.ancs4linux-desktop-integration = {
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${ancs4linux}/bin/ancs4linux-desktop-integration";
    serviceConfig.Restart = "on-failure";
    serviceConfig.RestartSec = 3;
  };

  # Archives every notification to ~/.local/share/ancs4linux/history.db.
  # Browse with: ancs4linux-history list | search <text> | tui
  systemd.user.services.ancs4linux-history = {
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${ancs4linux-history}/bin/ancs4linux-history log";
    serviceConfig.Restart = "on-failure";
    serviceConfig.RestartSec = 3;
  };
}
