{
  pythonShell = {mkShell, stable, unstable, ...}: mkShell rec {
    python = stable.python310;
    name = "pip-env";
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

      stable.jetbrains.pycharm-professional
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
      (with dotnetCorePackages; combinePackages [
        sdk_6_0
        sdk_7_0
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
      # rider EAP, with dotCover fix and copilot plugin
      # - copilot won't work by installing through GUI
      # - .NET 8 features aren't available on non-EAP yet

      (jetbrains.plugins.addPlugins (jetbrains.rider.overrideAttrs (old: rec {
        # https://download.jetbrains.com/rider/JetBrains.Rider-2023.3-EAP8-233.11799.49.Checked.tar.gz
        version = "2023.3-EAP8-233.11799.49.Checked";
        name = "rider-${version}";
        src = unstable.fetchurl {
          url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
          sha256 = "sha256-5pY1aa/EfTUdaJisqNiRg0ibf90YBM+yRv0d5gc0LjY=";
        };
        postPatch = old.postPatch + ''
          interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
          patchelf --set-interpreter $interp plugins/dotCommon/DotFiles/linux-x64/JetBrains.Profiler.PdbServer
        '';
      })) [ "github-copilot" ])
    ];

    packages = stablePackages ++ unstablePackages;
  };
}