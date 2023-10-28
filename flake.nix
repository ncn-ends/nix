{
  inputs = {
    stable.url = "github:NixOS/nixpkgs/master";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devShellFlake.url = "./dev-shells";
  };

  outputs = {self, stable, unstable, devShellFlake, flake-utils}:
    let 
      eachDefaultSystem = flake-utils.lib.eachDefaultSystem;

      defineShells = { stablePkgs, unstablePkgs }: 
        let 
          mkShell = stablePkgs.mkShell;
          passShellInputs = { inherit mkShell stablePkgs unstablePkgs; };
        in {
          devShells.node = devShellFlake.lib.nodeShell passShellInputs;
          devShells.dotnet = devShellFlake.lib.dotnetShell passShellInputs;
        };

    in eachDefaultSystem (system: defineShells {
      stablePkgs = import stable { inherit system; config.allowUnfree = true; };
      unstablePkgs = import unstable { inherit system; config.allowUnfree = true; };
    });
}