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
          imports = import ./helpers/import-packages.nix { inherit system inputs; };
          lib = inputs.stable.lib;
          callPackage = imports.stable.callPackage;
        in
        {
          devShells = {
            ${system} = import ./shells.nix { inherit imports; };
          };

          nixosConfigurations = callPackage ./machine.main.nix { inherit machines lib sops-nix imports drives home-manager; };

          darwinConfigurations =
            let
              machine = machines.macbook;
              # packages = import ./modules/package-dump.nix { inherit imports machine lib; };
            in
            {
              ${machine.hostName} = darwin.lib.darwinSystem {
                inherit system;
                specialArgs = {
                  inherit self machine imports;
                  name = machine.user;
                  unstable = imports.unstable;
                  stable = imports.stable;
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
