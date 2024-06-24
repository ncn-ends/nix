{ imports, config, ...}: {
  environment.systemPackages = [ imports.stable.caddy ];
  services.caddy = {
    enable = true;
    # virtualHosts = {
    #   "localhost:5233".extraConfig = ''
    #     encode gzip
    #     reverse_proxy localhost:5232
    #   '';
    # };
  };
}


    # virtualHosts = {
    #   "nixos.tail7d98c.ts.net".extraConfig = ''
    #     encode gzip

    #     handle_path /vw/* {
    #       reverse_proxy localhost:8222
    #     }

    #     handle_path /sync* {
    #       reverse_proxy localhost:9080
    #     }

    #     handle_path /cal/* {
    #       encode gzip

    #       reverse_proxy localhost:5232
    #     }

    #     handle_path /ping {
    #       respond "pong"
    #     }
    #   '';
    # };

    # virtualHosts.    # virtualHosts."hub.ncn.dev".extraConfig = ''
    #   handle / {
    #     respond "hello"
    #   }

    #   handle_path /vw/* {
    #     reverse_proxy localhost:8222
    #   }
    # '';

      # log {
      #   output file /var/log/caddy/access.log
      # }