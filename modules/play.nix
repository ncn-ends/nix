{ stable, unstable, config, services, name, ... }:
{
  environment.systemPackages = [
    stable.lutris
  ];

  programs.steam.enable = true;
  programs.gamemode.enable = true;
  
  home-manager.users.${name} = { ... }: {
    home.file.".local/share/Steam/steamapps/common/Counter-Strike Global Offensive/game/csgo/cfg/autoexec.cfg".source = ../configs/csgo/autoexec.cfg;
  };
}