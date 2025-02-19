{machines, lib, sops-nix, imports, drives, home-manager, ...} :  
let
  machine = machines.main;
  packages = import ./modules/package-dump.nix { inherit imports machine; };
in
  lib.nixosSystem {
    specialArgs = {
      inherit sops-nix imports drives machine;
    };
    modules = [
      home-manager.nixosModules.home-manager
      ./modules/foundation.nix
      ./modules/foundation.main.nix
      ./modules/sops.nix
      ./modules/cli.nix
      ./modules/desktop.cinnamon.nix
      ./modules/vscode.nix
      ./modules/vm.nix
      ./modules/server.firewall.nix
      ./modules/server.plex.nix
      ./modules/server.syncthing.nix
      ./modules/server.tailscale.nix
      ./modules/server.vaultwarden.nix
      ./modules/server.caddy.nix
      ./modules/server.ssh.nix
      ./modules/server.calendar.nix
      ./modules/server.rclone.nix
      ./modules/server.logging.nix
      ./modules/play.nix
      ./modules/nordvpn.nix
      {
        users.users.${machine.user}.packages =
          packages.all
          ++ packages.work
          ++ packages.personal
          ++ packages.personalLinux
          ++ packages.experimenting;
      }
    ];
  }