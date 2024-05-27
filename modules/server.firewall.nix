{ config, ...}:
{
  networking.firewall = { 
    enable = true;

    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedTCPPorts = [
      22 # ssh
      80 # http
      443 # https
    ];
  };
}