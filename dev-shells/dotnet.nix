{mkShell, imports, ...} : 
let 
  stable = imports.stable;
  unstable = imports.unstable;
in mkShell rec {
  name = "ncn-dotnet8-env";


  stablePackages = with stable; [
    (with dotnetCorePackages; combinePackages [
      sdk_6_0
      sdk_7_0
      sdk_8_0
    ])
  ];

  unstablePackages = with unstable; [
    # rider, with dotCover fix and copilot plugin
    # - copilot won't work by installing through GUI
    (jetbrains.plugins.addPlugins (jetbrains.rider.overrideAttrs (old: {
      postPatch = old.postPatch + ''
        interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
        patchelf --set-interpreter $interp plugins/dotCommon/DotFiles/linux-x64/JetBrains.Profiler.PdbServer
      '';
    })) [ "github-copilot" ])
  ];

  packages = stablePackages ++ unstablePackages;
}
