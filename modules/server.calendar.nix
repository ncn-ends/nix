{ drives, lib, ... }: 
let 
  radicaleLocation =  "${drives.shape.location}/radicale";
in {
  systemd.tmpfiles.rules = [
    "d ${radicaleLocation} 0775 radicale radicale -"
  ];

  services.radicale = {
    enable = true;
    settings.server.hosts = [ 
      "0.0.0.0:5232" 
      "[::]:5232" 
    ];
    settings.storage.filesystem_folder = radicaleLocation;
  };

  networking.firewall.allowedTCPPorts = [ 5232 5233 ];
}

# defaults to localhost:5232