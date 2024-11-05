{mkShell, imports, ...} : 
let 
  stable = imports.stable;
  unstable = imports.unstable;
  overrides = imports.overrides;
in mkShell rec {
  name = "ncn-dotnet8-env-azure-functions-2";

  packages = [
    unstable.azure-functions-core-tools
    (with stable.dotnetCorePackages; combinePackages [
      sdk_6_0
      sdk_7_0
      sdk_8_0
    ])
    # rider, with dotCover fix and copilot plugin
    # - copilot won't work by installing through GUI
    (stable.jetbrains.plugins.addPlugins (stable.jetbrains.rider.overrideAttrs (old: {
      postPatch = old.postPatch + ''
        interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
        patchelf --set-interpreter $interp plugins/dotCommon/DotFiles/linux-x64/JetBrains.Profiler.PdbServer
      '';
    })) [ "github-copilot" ])
  ];
}
