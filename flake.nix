{
  inputs = {
    stable.url = "github:NixOS/nixpkgs/master";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "stable";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "stable";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "stable";
  };

  outputs = inputs@{self, darwin, home-manager, sops-nix, ...}:
  let 
    machines = {
      main = {
        hostName = "nixos";
        user = "one";
        nixConfigRoot = "/etc/nixos";
      };
      macbook = {
        hostName = "ncns-MacBook-Pro";
        user = "ncn";
        nixRoot = "/Users/ncn/nix2";
      };
    };
    defineConfigBySystem = system: 
      let 
        passPksImportInput = { inherit system; config.allowUnfree = true; };
        unstable = import inputs.unstable passPksImportInput;
        stable = (import ./helpers/apply-overrides.nix (import inputs.stable passPksImportInput));
        lib = inputs.stable.lib;
        mkShell = stable.mkShell;
        devShellInputs = { inherit mkShell stable unstable; };
      in {
        devShells = {
          ${system} = {
            node = import ./dev-shells/node.nix devShellInputs;
            py = import ./dev-shells/py.nix devShellInputs;
            dotnet = import ./dev-shells/dotnet.nix  devShellInputs;
            rust = import ./dev-shells/rust.nix  devShellInputs;
          };
        };

        nixosConfigurations = {
          ${machines.main.hostName} = lib.nixosSystem {
            specialArgs = {
              inherit unstable sops-nix stable;
              name = machines.main.user;
            };
            modules = [
              ./modules/hardware-configuration.nix
              home-manager.nixosModules.home-manager
              ./modules/secrets.nix
              ./modules/foundation.common.nix
              ./modules/foundation.main.nix
              ./modules/system.nix
              ./modules/desktop.nix
              ./modules/gui.common.nix
              ./modules/vscode.nix
              ./modules/gui.home.nix
              ./modules/vm.nix
              ./modules/server.nix
              ./modules/server.syncthing.nix
              ./modules/server.tailscale.nix
              ./modules/server.vaultwarden.nix
              ./modules/server.caddy.nix
              # ./modules/server.seafile.nix
              # ./modules/server.minecraft.nix
              ./modules/play.nix
            ];
          };
        };

        darwinConfigurations = {
          ${machines.macbook.hostName} = darwin.lib.darwinSystem {
            inherit system;
            specialArgs = {
              inherit self unstable stable;
              name = machines.macbook.user;
            };
            modules = [ 
              home-manager.darwinModules.home-manager
              ./modules/system.nix
              ./modules/foundation.common.nix
              ./modules/foundation.mac.nix
              ./modules/vscode.nix
            ];
          };
        };
      };
    
    linux64Config = defineConfigBySystem "x86_64-linux";
    macM1Config = defineConfigBySystem "aarch64-darwin";
    final = {
      eval = 2+2;
      devShells = linux64Config.devShells // macM1Config.devShells;
      nixosConfigurations = linux64Config.nixosConfigurations;
      darwinConfigurations = macM1Config.darwinConfigurations;
    };
  in final;
}