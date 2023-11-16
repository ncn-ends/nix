{
  inputs = {
    stable.url = "github:NixOS/nixpkgs/master";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "stable";
  };

  outputs = inputs@{self, home-manager, flake-utils, ...}:
    let 
      passPksImportInput = { system = defaultSystem; config.allowUnfree = true; };

      # --- reuse ---
      unstable = import inputs.unstable passPksImportInput;
      stable = import inputs.stable passPksImportInput;
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
            ./modules/foundation.main.nix
            ./modules/system.nix
            ./modules/desktop.nix
            ./modules/gui.common.nix
            ./modules/gui.home.nix
            ./modules/vm.nix
            ./modules/play.nix
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