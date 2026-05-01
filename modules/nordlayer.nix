{
  config,
  lib,
  pkgs,
  ...
}: let
  nordLayerPkg = pkgs.callPackage ({
    autoPatchelfHook,
    buildFHSEnvChroot,
    dpkg,
    fetchurl,
    lib,
    stdenv,
    sysctl,
    iptables,
    iproute2,
    procps,
    cacert,
    libxml2,
    libidn2,
    zlib,
    libcap_ng,
    wireguard-tools,
  }: let
    pname = "nordlayer";
    version = "3.4.3";

    nordLayerBase = stdenv.mkDerivation {
      inherit pname version;

      src = fetchurl {
        url = "https://downloads.nordlayer.com/linux/latest/debian/pool/main/nordlayer_${version}_amd64.deb";
        hash = "sha256-JLocUNTHXYXYefySns/YcSGWQe6cc220Z811Uw2iqzY=";
      };

      buildInputs = [libxml2 libidn2 libcap_ng];
      nativeBuildInputs = [dpkg autoPatchelfHook stdenv.cc.cc.lib];

      dontConfigure = true;
      dontBuild = true;

      unpackPhase = ''
        runHook preUnpack
        dpkg --extract $src .
        runHook postUnpack
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out
        mv usr/* $out/
        [ -d var ] && mv var/ $out/
        [ -d etc ] && mv etc/ $out/
        runHook postInstall
      '';
    };

    nordLayerFhs = buildFHSEnvChroot {
      name = "nordlayerd";
      runScript = "nordlayerd";

      targetPkgs = pkgs: [
        nordLayerBase
        sysctl
        iptables
        iproute2
        procps
        cacert
        libxml2
        libidn2
        zlib
        libcap_ng
        wireguard-tools
      ];

      extraBuildCommands = ''
        mkdir -p $out/usr/libexec/nordlayer
        for f in ${nordLayerBase}/libexec/nordlayer/*; do
          ln -s "$f" "$out/usr/libexec/nordlayer/$(basename $f)"
        done
      '';
    };
  in
    stdenv.mkDerivation {
      inherit pname version;

      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin $out/share
        ln -s ${nordLayerBase}/bin/nordlayer $out/bin
        ln -s ${nordLayerFhs}/bin/nordlayerd $out/bin
        [ -d ${nordLayerBase}/share ] && ln -s ${nordLayerBase}/share/* $out/share/ || true
        runHook postInstall
      '';

      meta = with lib; {
        description = "CLI client for NordLayer";
        homepage = "https://nordlayer.com";
        license = licenses.unfreeRedistributable;
        platforms = ["x86_64-linux"];
      };
    }) {};
in
  with lib; {
    options.myypo.services.custom.nordlayer.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable the NordLayer daemon.
      '';
    };

    config = mkIf config.myypo.services.custom.nordlayer.enable {
      networking.firewall.checkReversePath = false;

      environment.systemPackages = [nordLayerPkg];

      security.wrappers.nordlayer = {
        source = "${nordLayerPkg}/bin/nordlayer";
        setuid = true;
        owner = "root";
        group = "nordlayer";
        permissions = "u+rx,g+rx,o+rx";
      };

      users.groups.nordlayer = {};

      systemd.services.nordlayer = {
        description = "NordLayer daemon.";
        serviceConfig = {
          ExecStart = "${nordLayerPkg}/bin/nordlayerd";
          ExecStartPre = pkgs.writeShellScript "nordlayer-start" ''
            mkdir -m 700 -p /var/lib/nordlayer
          '';
          ExecStartPost = pkgs.writeShellScript "nordlayer-fix-socket" ''
            for i in $(seq 1 60); do
              if [ -S /run/nordlayer/nordlayer.sock ]; then
                chmod 0660 /run/nordlayer/nordlayer.sock
                exit 0
              fi
              sleep 0.5
            done
            echo "nordlayer socket not found after 30s" >&2
            exit 1
          '';
          NonBlocking = true;
          KillMode = "process";
          Restart = "on-failure";
          RestartSec = 5;
          RuntimeDirectory = "nordlayer";
          RuntimeDirectoryMode = "0750";
          Group = "nordlayer";
        };
        wantedBy = ["multi-user.target"];
        after = ["network-online.target"];
        wants = ["network-online.target"];
      };
    };
  }
