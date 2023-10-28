{
  inputs = {
    stable.url = "github:NixOS/nixpkgs/master";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {self, stable, unstable, devShellFlake, flake-utils}:
    let 
      eachDefaultSystem = flake-utils.lib.eachDefaultSystem;
      devShellsLib = import ./dev-shells.nix;

      defineShells = { stablePkgs, unstablePkgs }: 
        let 
          mkShell = stablePkgs.mkShell;
          passShellInputs = { inherit mkShell stablePkgs unstablePkgs; };
        in {
          devShells.node = devShellsLib.nodeShell passShellInputs;
          devShells.dotnet = devShellsLib.dotnetShell passShellInputs;
        };

    in eachDefaultSystem (system: defineShells {
      stablePkgs = import stable { inherit system; config.allowUnfree = true; };
      unstablePkgs = import unstable { inherit system; config.allowUnfree = true; };
    });
}