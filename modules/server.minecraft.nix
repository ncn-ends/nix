{ stable, config, ...}: {
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

  environment.systemPackages = [ stable.mcrcon ];
}