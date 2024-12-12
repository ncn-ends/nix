{mkShell, imports, ...} : 
let 
  oldstable = imports.oldstable;
  stable = imports.stable;
  unstable = imports.unstable;
  overrides = imports.overrides;
in mkShell rec {
  name = "ncn-dotnet8-env-azure-functions-3";

  packages = [
    stable.jetbrains.jdk
    oldstable.azure-functions-core-tools
    (with stable.dotnetCorePackages; combinePackages [
      # sdk_6_0
      # sdk_7_0
      sdk_8_0
    ])
    # rider, with dotCover fix and copilot plugin
    # - copilot won't work by installing through GUI
    # (stable.jetbrains.plugins.addPlugins (unstable.jetbrains.rider.overrideAttrs (old: {
    #   postPatch = old.postPatch + ''
    #     interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
    #     patchelf --set-interpreter $interp plugins/dotCommon/DotFiles/linux-x64/JetBrains.Profiler.PdbServer
    #   '';
    # })) [ "github-copilot" ])
    # stable.jetbrains.rider.overrideAttrs (old: {
    #   postPatch = old.postPatch + ''
    #     interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
    #     patchelf --set-interpreter $interp plugins/dotCommon/DotFiles/linux-x64/JetBrains.Profiler.PdbServer
    #   '';
    # })
    stable.jetbrains.rider
  ];

  # if there is ever a bug with the jdk, set it here. Rider will pick up the correct version using these environment variables
  # JDK_HOME = stable.jetbrains.jdk;
  # IDEA_JDK = "${stable.jetbrains.jdk}/lib/openjdk";
  # RIDER_JDK = "${stable.jetbrains.jdk}/lib/openjdk";
}
