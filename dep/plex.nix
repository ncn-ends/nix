{ pkgs, lib, ... }:
let plexpass = pkgs.plex.override {
  plexRaw = pkgs.plexRaw.overrideAttrs(old: rec {
    version = "1.32.2.7100-248a2daf0";
    src = pkgs.fetchurl {
      url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
      sha256 = "sha256-sXIK72mjYvmn5k6g4nxdR794ie78F8bSnRA2oLkF2Vc=";
    };
  });
}; 
in {
  services.plex = {
    enable = true;
    openFirewall = true;
    package = plexpass;
  };
}