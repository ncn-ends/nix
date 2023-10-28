{
  inputs = {
    stable.url = "github:NixOS/nixpkgs/master";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {self, stable, unstable, flake-utils}:
    let 
      eachDefaultSystem = flake-utils.lib.eachDefaultSystem;
      mkShell = stablePkgs.mkShell;

      defineShells = { stablePkgs, unstablePkgs }: {
        devShells.node = mkShell rec { 
          name = "node-env";
          
          stablePackages = with stablePkgs; [
            nodejs
            nodePackages.npm
            nodePackages.yarn
            nodePackages.pnpm
            nodePackages.javascript-typescript-langserver
            nodePackages.typescript
            ngrok
          ];

          unstablePackages = with unstablePkgs; [
            jetbrains.rider
            jetbrains.webstorm
          ];

          packages = stablePackages ++ unstablePackages;
        };

        devShells.dotnet6 = mkShell rec {
            name = "dotnet6-env";

            packages = [
              dotnet-sdk_6
              (jetbrains.rider.overrideAttrs (old: {
                postPatch = old.postPatch + ''
                  interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
                  patchelf --set-interpreter $interp plugins/dotCommon/DotFiles/linux-x64/JetBrains.Profiler.PdbServer
                '';
              }))
            ];
        };
      };
    in eachDefaultSystem (system: defineShells {
      stablePkgs = import stable { inherit system; config.allowUnfree = true; };
      unstablePkgs = import unstable { inherit system; config.allowUnfree = true; };
    });
}