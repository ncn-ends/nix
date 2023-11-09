{
  nodeShell = {mkShell, stable, unstable, ...}: mkShell rec { 
    name = "node-env";

    stablePackages = with stable; [
      nodejs
      nodePackages.npm
      nodePackages.yarn
      nodePackages.pnpm
      nodePackages.javascript-typescript-langserver
      nodePackages.typescript
      ngrok
    ];

    unstablePackages = with unstable; [
      jetbrains.rider
      jetbrains.webstorm
    ];

    packages = stablePackages ++ unstablePackages;
  };

  dotnetShell = {mkShell, stable, unstable} : mkShell rec {
    name = "dotnet-master-env";

    stablePackages = with stable; [
      (with dotnetCorePackages;combinePackages [
        sdk_6_0
        sdk_7_0
      ])
    ];

    unstablePackages = with unstable; [
      (jetbrains.rider.overrideAttrs (old: {
        postPatch = old.postPatch + ''
          interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
          patchelf --set-interpreter $interp plugins/dotCommon/DotFiles/linux-x64/JetBrains.Profiler.PdbServer
        '';
      }))
    ];

    packages = stablePackages ++ unstablePackages;
  };
}