{ stable, config, ...}: {
  networking.firewall = { 
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/games/minecraft-server.nix
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    # dataDir = TODO: set it properly here

    # see here for more info: https://minecraft.gamepedia.com/Server.properties#server.properties
    serverProperties = {
      server-port = 25565;
      gamemode = "survival";
      motd = "NixOS Minecraft server on Tailscale!";
      max-players = 5;

      enable-rcon = true;
      "rcon.password" = "pw";

      level-seed = "10292992";
      hardcore = false;
      # enforce-whitelist = true; # TODO: this doesn't work
    };
  };

  environment.systemPackages = [ stable.tailscale stable.mcrcon ];
  services.tailscale.enable = true;

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
      ${tailscale}/bin/tailscale up -authkey $(cat ${config.sops.secrets."tailscale-minecraft".path})
    '';
  };

}