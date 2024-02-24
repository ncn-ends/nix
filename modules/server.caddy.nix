{ stable, config, ...}: {
  environment.systemPackages = [stable.caddy];
  services.caddy = {
    enable = true;

    virtualHosts."nixos.tail7d98c.ts.net".extraConfig = ''
      handle_path /vw/* {
        reverse_proxy localhost:8222
      }

      handle_path /sync* {
        reverse_proxy localhost:9080
      }
    '';
    # virtualHosts."hub.ncn.dev".extraConfig = ''
    #   handle / {
    #     respond "hello"
    #   }

    #   handle_path /vw/* {
    #     reverse_proxy localhost:8222
    #   }
    # '';
  };
}


      # log {
      #   output file /var/log/caddy/access.log
      # }