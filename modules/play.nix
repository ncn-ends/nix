{ imports, config, services, machine, ... }:
{
  xdg.portal.enable = true; # required for flatpak
  services.flatpak.enable = true;
  #   - bottles

  environment.systemPackages = [
    imports.stable.lutris
  ];

  programs.steam = {
    enable = true;
    extraCompatPackages = [
      imports.stable.proton-ge-bin.steamcompattool
    ];
  };

  programs.gamemode.enable = true;
  
  home-manager.users.${machine.user} = { ... }: {
    home.file.".local/share/Steam/steamapps/common/Counter-Strike Global Offensive/game/csgo/cfg/autoexec.cfg".source = ../configs/csgo/autoexec.cfg;

    home.packages = [
      imports.stable.prismlauncher
    ];
  };
}