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
      # stable.jetbrains.webstorm

      stable.libuuid # required for cypress and jest testing
    ];

    shellHook = ''
      export LD_LIBRARY_PATH = ${stable.lib.makeLibraryPath [stable.libuuid]};
    '';
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
      unstable.azure-functions-core-tools
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
      unstable.jetbrains.rider

      # not necessary unless you're running powershell scripts
      stable.powershell
      # stable.openssl
      # stable.update-ca-certificates

      stable.nodejs
      stable.yarn
      stable.nodePackages.npm
      # nodePackages.pnpm
      # nodePackages.javascript-typescript-langserver
      # nodePackages.typescript
      # ngrok

      stable.libuuid # required for cypress testing
    ];

    # if there is ever a bug with the jdk, set it here. Rider will pick up the correct version using these environment variables
    # JDK_HOME = stable.jetbrains.jdk;
    # IDEA_JDK = "${stable.jetbrains.jdk}/lib/openjdk";
    # RIDER_JDK = "${stable.jetbrains.jdk}/lib/openjdk";

    # shellHook = ''
    #   export LD_LIBRARY_PATH=${stable.openssl}/lib:$LD_LIBRARY_PATH
    #   export AZURE_CREDENTIALS_PATH="$HOME/.local/share/JetBrains/Rider${stable.jetbrains.rider.version}/azure"
    #   export LOCALAPPDATA="$HOME/.local/share"
    # '';
  };
  aspire =
    let
      fhsEnv = stable.buildFHSUserEnv {
        name = "aspire-fhs";
        targetPkgs = pkgs: (with pkgs; [
          jetbrains.jdk
          azure-functions-core-tools
          dotnetCorePackages.sdk_8_0
          jetbrains.rider
          powershell
          nodejs
          yarn
          nodePackages.npm
          # Core libraries for .NET and Aspire
          icu
          openssl
          zlib
          libuuid
          krb5
          lttng-ust_2_12
          stdenv.cc.cc.lib
          # Additional runtime dependencies
          curl
          libunwind
          git
          which
        ]);
        extraBwrapArgs = [
          "--ro-bind /etc/subuid /etc/subuid"
          "--ro-bind /etc/subgid /etc/subgid"
          "--ro-bind /run/wrappers /run/wrappers"
          "--bind /run/user /run/user"
          "--share-net"
        ];
        profile = ''
          # Mutable dotnet location for workload installs
          export DOTNET_INSTALL_DIR="$HOME/.dotnet-aspire"
          
          # Copy SDK if not already there
          if [ ! -d "$DOTNET_INSTALL_DIR/sdk" ]; then
            echo "Setting up mutable .NET SDK (one-time)..."
            mkdir -p "$DOTNET_INSTALL_DIR"
            cp -r ${stable.dotnetCorePackages.sdk_8_0}/share/dotnet/* "$DOTNET_INSTALL_DIR/"
            chmod -R u+w "$DOTNET_INSTALL_DIR"
          fi
          
          export DOTNET_ROOT="$DOTNET_INSTALL_DIR"
          export PATH="$DOTNET_INSTALL_DIR:$PATH"
          export SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt
          export CONTAINER_HOST="unix:///run/user/1000/podman/podman.sock"
          export DOTNET_SYSTEM_NET_DISABLEIPV6=1
        '';
        runScript = "bash";
      };
  in stable.mkShell {
    name = "aspire-launcher";
    buildInputs = [ fhsEnv ];
    shellHook = ''
      echo "================================================"
      echo "Aspire Development Environment"
      echo "================================================"
      echo "1. Run 'aspire-fhs' to enter the FHS environment"
      echo "2. If not run before, run 'dotnet workload install aspire'"
      echo "3. Run 'dotnet restore' in Aspire directory"
      echo "4. Run 'dotnet run' in Aspire directory"
      echo ""
      echo "Tip: You may need to run 'dotnet clean' targeting the solution. If so, make sure to run 'dotnet dev-certs https' as well."
      echo "================================================"
    '';
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
  rust = mkShell {
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

  #   _____
  #  / ____|
  # | |     
  # | |     
  # | |____ 
  #  \_____|
  c = mkShell {
    # make install CFLAGS="-Wno-unused-result"
    # solid, blink, cycle, wave, lightning, and pulse.
    # Default solid color (#f20000, red) for the whole micro:
    # quadcastrgb solid 
    # # Random blinking colors:
    # quadcastrgb blink
    # # Default cycle (rainbow) mode for the whole micro:
    # quadcastrgb -a cycle 
    # # Purple color for the upper part and yellow for the lower:
    # quadcastrgb -u solid 4c0099 -l solid ff6000 
    # # Default cycle mode for the upper diode with 50% brightness and yellow lightning for the lower:
    # quadcastrgb -u -b 50 cycle -l lightning ff6000 

    # white on bottom, blue on top
    # sudo killall quadcastrgb; sudo ./quadcastrgb -u pulse 0057a9 -b 50 -l solid ffea77 -b 100

    # blue on top, green on bottom
    # sudo killall quadcastrgb; sudo ./quadcastrgb -u pulse 0057a9 -b 50 -l solid 002700 -b 100
    name = "ncn-c-env";

    packages = [
      stable.gnumake
      stable.libusb1
    ];
  };
})