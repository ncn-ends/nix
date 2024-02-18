{ stable, config, ...}: {
  environment.systemPackages = [stable.caddy];
  services.caddy = {
    enable = true;

    virtualHosts."nixos.tail7d98c.ts.net".extraConfig = ''
      handle_path /vw/* {
        reverse_proxy localhost:8222
      }
    '';
  };
}