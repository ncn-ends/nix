{
  inputs = {
    stable.url = "github:NixOS/nixpkgs/master";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = { 
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "stable";
    };
  };

  outputs = {stable, unstable, flake-utils, home-manager, ...}:
    let 
      # reuse
      defaultSystem = "x86_64-linux";
      hostname = "nixos";
      stablePkgs = import stable { system = defaultSystem; config.allowUnfree = true; };
      unstablePkgs = import unstable { system = defaultSystem; config.allowUnfree = true; };
      lib = stable.lib;

      # shell
      devShellsLib = import ./dev-shells.nix;
      mkShell = stablePkgs.mkShell;
      passShellInputs = { inherit stablePkgs unstablePkgs mkShell; };

      # nixos

      final = {
        eval = 2 + 2;
        devShells.${defaultSystem} =  {
          node = devShellsLib.mkNodeShell passShellInputs;
          dotnet = devShellsLib.mkDotnetShell passShellInputs;
        };
        nixosConfigurations = {
          ${hostname} = lib.nixosSystem {
            system = defaultSystem;
            specialArgs = {
              inherit stablePkgs unstablePkgs;
              pkgs = stablePkgs;
            };

            modules = [
              ./modules/hardware-configuration.nix
              ./modules/global.nix
              ./modules/foundation.nix
              ./modules/cinnamon.desktop.nix
              ./modules/users.nix
              ./modules/packages.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.one = import ./home.nix;
                home-manager.extraSpecialArgs = {inherit stablePkgs unstablePkgs; };
              }
              {
                system.stateVersion = "21.11"; # DO NOT CHANGE
                nixpkgs.config.allowUnfree = true;
              }
            ];
          };
        };
      };

    in final; 
}

      # eachDefaultSystem = flake-utils.lib.eachDefaultSystem;
      # defineShells = { stablePkgs, unstablePkgs }: 
      #   let 
      #     mkShell = stablePkgs.mkShell;
      #     passShellInputs = { inherit mkShell stablePkgs unstablePkgs; };
      #   in {
      #     devShells.node = devShellsLib.nodeShell passShellInputs;
      #     devShells.dotnet = devShellsLib.dotnetShell passShellInputs;
      #   };

      # final = eachDefaultSystem (system: defineShells {
      #   stablePkgs = import stable { inherit system; config.allowUnfree = true; };
      #   unstablePkgs = import unstable { inherit system; config.allowUnfree = true; };
      # });

      # defineShells = eachDefaultSystem (system: 
      #   let 
      #     stablePkgs = import stable { inherit system; config.allowUnfree = true; };
      #     unstablePkgs = import unstable { inherit system; config.allowUnfree = true; };
      #     mkShell = stablePkgs.mkShell;

      #     passShellInputs = { inherit mkShell stablePkgs unstablePkgs; };
      #   in {
      #     node = devShellsLib.mkNodeShell passShellInputs;
      #     dotnet = devShellsLib.mkDotnetShell passShellInputs;
      #   }
      # );