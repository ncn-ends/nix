{
  nodeShell = {mkShell, stablePkgs, unstablePkgs}: mkShell rec { 
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

  dotnetShell = {mkShell, stablePkgs, unstablePkgs} : mkShell rec {
    name = "dotnet-master-env";

    stablePackages = with stablePkgs; [
      (with dotnetCorePackages;combinePackages [
        sdk_6_0
        sdk_7_0
      ])
    ];

    unstablePackages = with unstablePkgs; [
      (with dotnetCorePackages;combinePackages [
        sdk_6_0
        sdk_7_0
      ])
      (jetbrains.rider.overrideAttrs (old: {
        postPatch = old.postPatch + ''
          interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
          patchelf --set-interpreter $interp plugins/dotCommon/DotFiles/linux-x64/JetBrains.Profiler.PdbServer
        '';
      }))
    ];

    packages = stablePackages ++ unstablePackages;
  };

  reactNativeShell = {mkShell, stablePkgs, unstablePkgs, ...}: 
    # resources:
    #   https://nixos.org/manual/nixpkgs/unstable/#android

    let
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
      };
      # unstablePkgs = (import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) { inherit config; });
      # stablePkgs = (import fetchFromGitHub {
      #   owner = "NixOS";
      #   repo = "nixpkgs";
      #   rev = "master";
      #   sha256 = "sha256-TmDDLkbi6JJ9QP/q3ID0dipDzjqFjxTzvE1fYMvYwYQ=";
      # } { inherit config; });
      

      AAPT_BUILD_TOOLS = "33.0.0";
      cmakeVersion="3.18.1";
      androidComposition = stablePkgs.androidenv.composeAndroidPackages {
        # not sure
        cmdLineToolsVersion = "8.0";
        toolsVersion = "26.1.1";
        emulatorVersion = "33.1.6";
        includeSources = false;
        includeSystemImages = true;
        systemImageTypes = [ "google_apis_default" ];
        abiVersions = [ "x86_64" ];
        includeNDK = true;
        ndkVersions = ["23.1.7779620"];
        includeExtras = [ "extras;google;gcm" ];

        # intentional
        includeEmulator = true;
        cmakeVersions = [ cmakeVersion ];
        platformVersions = ["30" "33"];
        buildToolsVersions = ["30.0.3" AAPT_BUILD_TOOLS];
        platformToolsVersion = "33.0.3";
      };
      androidsdk = androidComposition.androidsdk;
      platform-tools = androidComposition.platform-tools;
    in mkShell rec { 
      name = "react-native-env";

      # gradle and watchman are included without explicitly being defined
      # react native cli must be called with npx - react-native-cli has been deprecated in nixpkgs
      stablePackages = with stablePkgs; [
        nodejs
        yarn
        nodePackages_latest.typescript
        androidsdk
        platform-tools
        # emulator

        # i think 11 is least likely to cause problems with react native / android studio. may not be true
        jdk11         

        # not sure what its for but just in case
        glibc
      

      ];

      # unstablePackages = with unstablePkgs; [
      # ];

      # packages = stablePackages ++ unstablePackages;
      packages = stablePackages;

      # for debugging 
      ANDROID_SDK_STORE_ROOT = "${androidsdk}";

      # this is deprecated, but some tools may need it
      ANDROID_HOME ="${androidsdk}/libexec/android-sdk";
      ANDROID_SDK_ROOT = "${ANDROID_HOME}";
      ANDROID_NDK_ROOT = "${ANDROID_SDK_ROOT}/ndk-bundle";
      GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_SDK_ROOT}/build-tools/${AAPT_BUILD_TOOLS}/aapt2";
      USE_CCACHE = 1;

      # androidenv.emulateApp {
      #   name = "Pixel_4_API_33";
      #   platformVersion = "33";
      #   abiVersion = "x86";
      #   systemImageType = "google_apis";
      # }

      # this is in case we use cmake, although not sure if we do. if we don't, then this is unnecessary
      shellHook = ''
        export PATH="$(echo "$ANDROID_SDK_ROOT/cmake/${cmakeVersion}".*/bin):$PATH"
      '';
    };
}

# /nix/store/m4506l916fj9zwl7rwan4i4yzp40mzjk-androidsdk/libexec/android-sdk/emulator/emulator @Pixel_XL_API_33