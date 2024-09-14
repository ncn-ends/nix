{ imports, config, services, machine, ... }:
{
  xdg.portal.enable = true; # required for flatpak
  services.flatpak.enable = true;
  #   - was using flatpak for bottles, but switched to system package. keep flatpak for now

  environment.systemPackages = [
    imports.stable.bottles
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