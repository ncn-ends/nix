{mkShell, imports, ...}: 
let 
  stable = imports.stable;
  unstable = imports.unstable;
in mkShell rec {
  name = "ncn-dotnet-rollback";

  stablePackages = with stable; [
    (with dotnetCorePackages;combinePackages [
      sdk_6_0
      sdk_7_0
      sdk_8_0
    ])
  ];

  unstablePackages = with unstable; [
    # rider EAP, with dotCover fix and copilot plugin
    # - copilot won't work by installing through GUI
    # - .NET 8 features aren't available on non-EAP yet

    (jetbrains.plugins.addPlugins (jetbrains.rider.overrideAttrs (old: rec {
      # https://www.jetbrains.com/rider/download/other.html
      version = "2024.2";
      name = "rider-${version}";
      src = unstable.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
        sha256 = "sha256-tozH8Qk0fO25OBfMNabh8AibIF5q5a6M5AD7sv9hPAo=";
      };
      postPatch = old.postPatch + ''
        interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
        patchelf --set-interpreter $interp plugins/dotCommon/DotFiles/linux-x64/JetBrains.Profiler.PdbServer
      '';
    })) [ "github-copilot" ])
  ];

  packages = stablePackages ++ unstablePackages;
}