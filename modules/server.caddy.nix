{ stable, config, ...}: {

  services.caddy = {
    enable = true;

    virtualHosts."nixos.tail7d98c.ts.net".extraConfig = ''
      respond "Hello, world!"
    '';
  };

}