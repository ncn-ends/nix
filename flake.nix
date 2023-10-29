{
  inputs = {
    stable.url = "github:NixOS/nixpkgs/master";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {self, stable, unstable, flake-utils}:
    let 
      # reuse
      defaultSystem = "x86_64-linux";
      stablePkgs = import stable { system = defaultSystem; config.allowUnfree = true; };
      unstablePkgs = import unstable { system = defaultSystem; config.allowUnfree = true; };

      # shells
      mkDevShell = import ./dev-shells.nix;
      mkShell = stablePkgs.mkShell;
      passShellInputs = { inherit mkShell stablePkgs unstablePkgs; };

      final = {
        eval = 2 + 2;
        devShells.${defaultSystem} = {
          node = mkDevShell.nodeShell passShellInputs;
          dotnet = mkDevShell.dotnetShell passShellInputs;
        };
      };

    in final;
}