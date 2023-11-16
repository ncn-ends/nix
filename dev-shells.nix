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
        sdk_8_0
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

  dotnetEapShell = {mkShell, stable, unstable} : mkShell rec {
    name = "dotnet-eap-env";

    stablePackages = with stable; [
      (with dotnetCorePackages;combinePackages [
        sdk_6_0
        sdk_7_0
        sdk_8_0
      ])
    ];

    unstablePackages = with unstable; [
      (jetbrains.rider.overrideAttrs (old: rec {
        # https://download.jetbrains.com/rider/JetBrains.Rider-2023.3-EAP6-233.11555.23.Checked.tar.gz
        version = "2023.3-EAP6-233.11555.23.Checked";
        name = "rider-${version}";
        src = unstable.fetchurl {
          url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
          sha256 = "sha256-7dXtWXJlHnSOG7/BG2q3qzbuDJVFtICRTe8iUKCmQmQ=";
        };
        postPatch = old.postPatch + ''
          interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
          patchelf --set-interpreter $interp plugins/dotCommon/DotFiles/linux-x64/JetBrains.Profiler.PdbServer
        '';
      }))
    ];

    packages = stablePackages ++ unstablePackages;
  };
}