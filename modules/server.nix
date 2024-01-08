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
}