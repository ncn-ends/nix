{ imports, config, ...}: {
  environment.systemPackages = [ imports.stable.caddy ];

  networking.hosts."127.0.0.1" = [
    "invokeai.local"
    "immich.local"
    "grafana.local"
  ];

  services.caddy = {
    enable = true;
    virtualHosts = {
      "http://invokeai.local".extraConfig = ''
        reverse_proxy localhost:9090
      '';
      "http://immich.local".extraConfig = ''
        reverse_proxy localhost:2283
      '';
      "http://grafana.local".extraConfig = ''
        reverse_proxy localhost:3100
      '';
    };
  };
}
