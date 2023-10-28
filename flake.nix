{
  inputs = {
    stable.url = "github:NixOS/nixpkgs/master";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {self, stable, unstable, flake-utils}:
    let 
      eachDefaultSystem = flake-utils.lib.eachDefaultSystem;

      defineShells = { stablePkgs, unstablePkgs }: 
        let 
          mkShell = stablePkgs.mkShell;
        in {
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

          devShells.dotnet = mkShell rec {
            name = "dotnet-master-env";

            stablePackages = with stablePkgs; [
              (with dotnetCorePackages;combinePackages [
                sdk_6_0
                sdk_7_0
              ])
            ];

            unstablePackages = with unstablePkgs; [
              jetbrains.rider
              # (jetbrains.rider.overrideAttrs (old: {
              #   postPatch = old.postPatch + ''
              #     interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
              #     patchelf --set-interpreter $interp plugins/dotCommon/DotFiles/linux-x64/JetBrains.Profiler.PdbServer
              #   '';
              # }))
            ];

            packages = stablePackages ++ unstablePackages;
          };
        };

    in eachDefaultSystem (system: defineShells {
      stablePkgs = import stable { inherit system; config.allowUnfree = true; };
      unstablePkgs = import unstable { inherit system; config.allowUnfree = true; };
    });
}