{ inputs, supportedSystems, ...}: 
let 
  mkShellsForEachSystem = defineShell: builtins.listToAttrs (map (system: let 
    imports = import ./helpers/import-packages.nix {inherit system inputs;};
    stable = imports.stable;
    oldstable = imports.oldstable;
    unstable = imports.unstable;
    mkShell = stable.mkShell;
  in {
    name = system;
    value = defineShell {inherit stable oldstable unstable mkShell; };
  }) supportedSystems);
in mkShellsForEachSystem ({mkShell, stable, oldstable, unstable, ...}: {
  # default = stable.mkShell { packages = [ unstable.azure-functions-core-tools ]; };

  #  _   _           _      
  # | \ | |         | |     
  # |  \| | ___   __| | ___ 
  # | . ` |/ _ \ / _` |/ _ \
  # | |\  | (_) | (_| |  __/
  # |_| \_|\___/ \__,_|\___|
  node = mkShell {
    name = "ncn-node-env";

    packages = [
      stable.nodejs
      stable.yarn
      # nodePackages.npm
      # nodePackages.pnpm
      # nodePackages.javascript-typescript-langserver
      # nodePackages.typescript
      # ngrok
      stable.jetbrains.webstorm

      stable.libuuid # required for cypress testing
    ];
  };


  #  _____        _              _   
  # |  __ \      | |            | |  
  # | |  | | ___ | |_ _ __   ___| |_ 
  # | |  | |/ _ \| __| '_ \ / __| __|
  # | |__| | (_) | |_| | | |  __| |_ 
  # |_____/ \___/ \__|_| |_|\___|\__|
  dotnet = mkShell {
    name = "ncn-dotnet-env";

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
  };

  #  _____        _   _              
  # |  __ \ _   _| |_| |__   ___  _ __  
  # | |__) | | | | __| '_ \ / _ \| '_ \ 
  # |  ___/| |_| | |_| | | | (_) | | | |
  # |_|     \__, |\__|_| |_|\___/|_| |_|
  #         |___/
  py = mkShell rec {
    name = "ncn-python-env";
    python = stable.python310;
    patchShebangs = true;
    packages = with stable.python310.pkgs; [
      ipython
      pip
      setuptools
      virtualenvwrapper
      wheel

      stable.libffi
      stable.openssl
      stable.gcc
      stable.unzip

      # pip libraries
      # fastapi
      # uvicorn
      # httpx
      # pytest
      # pytest-asyncio
      # websockets
      # python-dotenv
      # aiohttp
      # python-multipart
      # requests

      # stable.jetbrains.pycharm-professional
    ];
    shellHook = ''
      VENV=.venv
      if test ! -d $VENV; then
        virtualenv $VENV
      fi
      source ./$VENV/bin/activate
      export PYTHONPATH=`pwd`/$VENV/${python.sitePackages}/:$PYTHONPATH
    '';
  };

  #  ____  _   _ ____ _____
  # |  _ \| | | / ___|_   _|
  # | |_) | | | \___ \ | |
  # |  _ <| |_| |___) || |
  # |_| \_\\___/|____/ |_|
  rust = {
    name = "ncn-rust-env";

    packages = [
      stable.cargo
      stable.rustc
      stable.rustfmt
      stable.openssl
      stable.pkg-config
      unstable.jetbrains.rust-rover
    ];
  };
})