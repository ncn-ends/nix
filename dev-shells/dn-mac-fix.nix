{mkShell, imports} : 
let 
  oldstable = imports.oldstable;
  stable = imports.stable;
  unstable = imports.unstable;
  overrides = imports.overrides;
in mkShell rec {
  name = "ncn-dn-mac-fix-env";


  stablePackages = with stable; [
    (with dotnetCorePackages; combinePackages [
      # sdk_6_0
      # sdk_7_0
      sdk_8_0
    ])
  ];

  unstablePackages = with unstable; [
    # rider, with dotCover fix and copilot plugin
    # - copilot won't work by installing through GUI
    # (jetbrains.rider.overrideAttrs (old: {
    #   postPatch = old.postPatch + ''
    #     interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
    #     patchelf --set-interpreter $interp plugins/dotCommon/DotFiles/linux-x64/JetBrains.Profiler.PdbServer
    #   '';
    # }))
    jetbrains.rider
  ];

  packages = stablePackages ++ unstablePackages;
}
