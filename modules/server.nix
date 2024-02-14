{ stable, config, ...}:
{
  # TODO: kde connect allowed ports should ideally be moved to gui.home.nix

  networking.firewall = { 
    enable = true;

    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
  };

  services.plex = {
    enable = true;
    openFirewall = true;
  };

  # services.jellyfin = {
  #   enable = true;
  #   openFirewall = true;
  # };

  # services.caddy = {
  #   enable = true;
  #   virtualHosts."http://watch.ncn.dev".extraConfig = ''
  #     reverse_proxy http://localhost:8096
  #   '';
  # };

  # https://wes.today/nixos-syncthing/
  services.syncthing = {
    enable = true;
    dataDir = "/run/media/one/shape1/syncthing";
    openDefaultPorts = true;
    configDir = "/home/one/.config/syncthing";
    user = "one";
    group = "users";
    guiAddress = "127.0.0.1:8384";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "s10" = { id = "RT5ULAR-676SHP6-WZ5UWS3-4VI3WBU-RNH5LJ7-PK3BOCZ-U6CAICR-L3SROAN"; };
        "razr" = { id = "placeholder"; };
        "one" = { id = "placeholder"; };
      };
      folders = {
        "dump" = {
          path = "/run/media/one/shape1/syncthing/dump";
          devices = [ "s10" ];
        };
      };
    };
  };
}