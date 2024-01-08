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

  outputs = inputs@{self, darwin, home-manager, flake-utils, sops-nix, ...}:
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
      macName = "ncn";

      # --- shells ---
      mkShell = stable.mkShell;
      passShellInputs = { inherit mkShell stable unstable; };

      defineShells = {
        ${defaultSystem} = {
          node = import ./dev-shells/node.nix passShellInputs;
          py = import ./dev-shells/py.nix passShellInputs;
          dotnet = import ./dev-shells/dotnet.nix  passShellInputs;
          dotnet8 = import ./dev-shells/dotnet8.nix  passShellInputs;
          dn-eap = import ./dev-shells/dn-eap.nix  passShellInputs;
        };
      };

      # # --- nixos ---
      defineNixOS = {
        ${hostName} = lib.nixosSystem {
          specialArgs = {
            inherit name unstable sops-nix;
            stable = (import ./helpers/apply-overrides.nix) stable;
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
            ./modules/minecraft.server.nix
            ./modules/play.nix
          ];
        };
      };

      # --- nix darwin ---
      defineNixDarwin = {
        ${macHostName} = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit self;
            name = macName;
            unstable = import inputs.unstable { system = "aarch64-darwin"; config.allowUnfree = true; };
            stable = import inputs.stable { system = "aarch64-darwin"; config.allowUnfree = true; };
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

      final = {
        eval = 2 + 2;
        devShells = defineShells;
        nixosConfigurations = defineNixOS;
        darwinConfigurations = defineNixDarwin;
      };

    in final;
}
