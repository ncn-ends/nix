{
  inputs = {
    stable.url = "github:NixOS/nixpkgs/master";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "stable";
  };

  outputs = {self, stable, unstable, home-manager, flake-utils}:
    let 
      # reuse
      defaultSystem = "x86_64-linux";
      stablePkgs = import stable { system = defaultSystem; config.allowUnfree = true; };
      unstablePkgs = import unstable { system = defaultSystem; config.allowUnfree = true; };

      # shells
      mkDevShell = import ./dev-shells.nix;
      mkShell = stablePkgs.mkShell;
      passShellInputs = { inherit mkShell stablePkgs unstablePkgs; };

      defineShells = {
        ${defaultSystem} = {
          node = mkDevShell.nodeShell passShellInputs;
          dotnet = mkDevShell.dotnetShell passShellInputs;
        };
      };

      final = {
        eval = 2 + 2;
        devShells = defineShells;
        nixosConfigurations = {
          nixos = stable.lib.nixosSystem {
            specialArgs = {
              stable = stablePkgs // {
                azure-cli = stablePkgs.azure-cli.override {
                  python3 = stablePkgs.python310;
                };
              };
              unstable = unstablePkgs;
            };
            modules = [
              {
                system.stateVersion = "21.11"; # DO NOT CHANGE
                nixpkgs.config.allowUnfree = true;
                nix.settings.experimental-features = [
                  "nix-command"
                  "flakes"
                ];
              }
              ./modules/hardware-configuration.nix
              # "${home-manager}/nixos"
              # <home-manager/nixos>
              home-manager.nixosModules.home-manager
              
              ./modules/foundation.nix
              ./modules/cinnamon.desktop.nix
              ./modules/users.nix
              ./modules/packages.nix
              ./modules/home.nix
            ];
          };
        };
      };

    in final;
}