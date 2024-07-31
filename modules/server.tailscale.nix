{ imports, config, ...}: 
let 
  stable = imports.stable;
in {

  # things done manually:
  #   tailscale up --advertise-exit-node

  services.tailscale.enable = true;
  environment.systemPackages = [ stable.tailscale ];
  # https://github.com/tailscale/tailscale/issues/4432
  services.tailscale.useRoutingFeatures = "server";
  services.tailscale.permitCertUid = "caddy";

  networking.firewall = { 
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";

    script = with stable; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey $(cat ${config.sops.secrets."tailscale".path})
    '';
  };
}