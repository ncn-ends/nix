{
  inputs = {
    oldstable.url = "github:NixOS/nixpkgs/nixos-23.11";

    stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    untested.url = "github:NixOS/nixpkgs/master";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "stable";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "stable";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "stable";
  };

  outputs = inputs@{ self, darwin, home-manager, sops-nix, ... }:
    let
      machines = {
        main = {
          hostName = "nixos";
          user = "one";
          nixConfigRoot = "/etc/nixos";
          system = "x86_64-linux";
        };
        macbook = {
          hostName = "ncns-MacBook-Pro";
          user = "ncn";
          nixConfigRoot = "/Users/ncn/nix2";
          system = "aarch64-darwin";
        };
      };
      drives = {
        shape = {
          location = "/mnt/shape";
        };
      };
      defineConfigBySystem = system:
        let
          passPksImportInput = { inherit system; config.allowUnfree = true; };
          oldstable = import inputs.oldstable passPksImportInput;
          stable = import inputs.stable passPksImportInput;
          unstable = import inputs.unstable passPksImportInput;
          untested = import inputs.untested passPksImportInput;
          lib = inputs.stable.lib;
          overrides = import ./helpers/apply-overrides.nix { packages = stable; lib = lib; };
          imports = { inherit stable unstable untested overrides oldstable; };
        in
        {
          devShells = {
            ${system} = import ./shells.nix { mkShell = stable.mkShell; inherit imports; };
          };

          nixosConfigurations =
            let
              machine = machines.main;
              packages = import ./modules/package-dump.nix { inherit imports machine lib; };
            in
            {
              ${machine.hostName} = lib.nixosSystem {
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
                  {
                    users.users.${machine.user}.packages =
                      packages.all
                      ++ packages.work
                      ++ packages.personal
                      ++ packages.personalLinux
                      ++ packages.experimenting;
                  }
                ];
              };
            };

          darwinConfigurations =
            let
              machine = machines.macbook;
              # packages = import ./modules/package-dump.nix { inherit imports machine lib; };
            in
            {
              ${machine.hostName} = darwin.lib.darwinSystem {
                inherit system;
                specialArgs = {
                  inherit self unstable stable machine imports;
                  name = machine.user;
                };
                modules = [
                  home-manager.darwinModules.home-manager
                  ./modules/foundation.macbook.nix
                  ./modules/cli.nix
                  ./modules/vscode.nix
                ];
              };
            };
        };

      linux64Config = defineConfigBySystem "x86_64-linux";
      macM1Config = defineConfigBySystem "aarch64-darwin";
      final = {
        eval = 2 + 2;
        devShells = linux64Config.devShells // macM1Config.devShells;
        nixosConfigurations = linux64Config.nixosConfigurations;
        darwinConfigurations = macM1Config.darwinConfigurations;
        # packages = linux64Config.packages;
      };
    in
    final;
}
