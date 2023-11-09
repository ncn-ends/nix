{
  inputs = {
    stable.url = "github:NixOS/nixpkgs/master";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "stable";
  };

  outputs = inputs@{self, home-manager, flake-utils, ...}:
    let 
      # reuse
      defaultSystem = "x86_64-linux";
      name = "one";
      stable = import inputs.stable { system = defaultSystem; config.allowUnfree = true; };
      unstable = import inputs.unstable { system = defaultSystem; config.allowUnfree = true; };
      lib = inputs.stable.lib;

      # shells
      mkDevShell = import ./dev-shells.nix;
      mkShell = stable.mkShell;
      passShellInputs = { inherit mkShell stable unstable; };

      defineShells = {
        ${defaultSystem} = {
          node = mkDevShell.nodeShell passShellInputs;
          dotnet = mkDevShell.dotnetShell passShellInputs;
        };
      };

      # nixos
      hostName = "nixos";
      defineNixOS = {
        ${hostName} = lib.nixosSystem {
          specialArgs = {
            inherit name unstable;
            stable = (import ./helpers/apply-overrides.nix) stable;
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
            home-manager.nixosModules.home-manager
            ./modules/foundation.nix
            ./modules/cinnamon.desktop.nix
            ./modules/users.nix
            ./modules/packages.nix
            ./modules/home.nix
          ];
        };
      };

      final = {
        eval = 2 + 2;
        devShells = defineShells;
        nixosConfigurations = defineNixOS;
      };

    in final;
}