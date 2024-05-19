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
      "0.0.0.0:5233" 
      "[::]:5233" 
    ];
    settings.storage.filesystem_folder = radicaleLocation;
  };
}

# defaults to localhost:5232