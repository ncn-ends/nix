{
  inputs = {
    stable.url = "github:NixOS/nixpkgs/master";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "stable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "stable";
  };

  outputs = inputs@{self, darwin, home-manager, flake-utils, ...}:
    let 
      passPksImportInput = { system = defaultSystem; config.allowUnfree = true; };

      # --- reuse ---
      unstable = import inputs.unstable passPksImportInput;
      stable = import inputs.stable passPksImportInput;
      macHostName = "ncns-MacBook-Pro";
      defaultSystem = "x86_64-linux";
      lib = inputs.stable.lib;
      hostName = "nixos";
      name = "one";

      # --- shells ---
      mkDevShell = import ./dev-shells.nix;
      mkShell = stable.mkShell;
      passShellInputs = { inherit mkShell stable unstable; };

      defineShells = {
        ${defaultSystem} = {
          node = mkDevShell.nodeShell passShellInputs;
          dotnet = mkDevShell.dotnetShell passShellInputs;
          dn-eap = mkDevShell.dotnetEapShell passShellInputs;
        };
      };

      # --- nixos ---
      defineNixOS = {
        ${hostName} = lib.nixosSystem {
          specialArgs = {
            inherit name unstable;
            stable = (import ./helpers/apply-overrides.nix) stable;
          };
          modules = [
            ./modules/hardware-configuration.nix
            home-manager.nixosModules.home-manager
            ./modules/foundation.common.nix
            ./modules/foundation.main.nix
            ./modules/system.nix
            ./modules/desktop.nix
            ./modules/gui.common.nix
            ./modules/vscode.nix
            ./modules/gui.home.nix
            ./modules/vm.nix
            ./modules/server.nix
            ./modules/play.nix
          ];
        };
      };

      # --- nix darwin ---
      defineNixDarwin = {
        ${macHostName} = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit unstable self;
            name = "ncn";
            stable = (import ./helpers/apply-overrides.nix) stable;
          };
          modules = [ 
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."ncn" = { pkgs, ... }: {
                home.username = "ncn";
                home.stateVersion = "22.11";
                programs.home-manager.enable = true;
                nixpkgs.config.allowUnfree = true;
              };
            }
            ./nix-darwin.nix
            ./modules/vscode.nix
          ];
        };
      };

      final = {
        eval = 2 + 2;
        devShells = defineShells;
        nixosConfigurations = defineNixOS;
        darwinConfigurations = defineNixDarwin;
      };

    in final;
}
