{ stable, unstable, config, services, name, ... }:
{
  xdg.portal.enable = true; # required for flatpak
  services.flatpak.enable = true;
  #   - bottles

  environment.systemPackages = [
    stable.lutris
  ];

  programs.steam = {
    enable = true;
    extraCompatPackages = [
      stable.proton-ge-bin.steamcompattool
    ];
  };

  programs.gamemode.enable = true;
  
  home-manager.users.${name} = { ... }: {
    home.file.".local/share/Steam/steamapps/common/Counter-Strike Global Offensive/game/csgo/cfg/autoexec.cfg".source = ../configs/csgo/autoexec.cfg;

    home.packages = [
      stable.prismlauncher
    ];
  };
}