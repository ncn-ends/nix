{ stable, services, name, ... }:
{
  services.xserver = {
    enable = true;
    libinput.enable = true;
    displayManager.lightdm.enable = true;
    displayManager.defaultSession = "cinnamon";
    desktopManager.cinnamon.enable = true;
    videoDrivers = [ "amdgpu" ];
  };
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with stable; [
      amdvlk
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  home-manager.users.${name} = { ... }: {
    programs.rofi = {
      enable = true;
      theme = ../configs/rofi/theme.rasi;
    };
    services.polybar = {
      enable = true;
      script = "polybar bar &";
      config = ../configs/polybar/config.ini;
      package = stable.polybar;
    };

    home.packages = [ 
      stable.xbindkeys
      stable.screenkey
    ];

    home.file.".config/autostart/.screenkey.desktop".source   = ../configs/startup/screenkey.desktop;
    home.file.".config/autostart/.flameshot.desktop".source   = ../configs/startup/flameshot.desktop;
    home.file.".config/autostart/.xbindkeys.desktop".source   = ../configs/startup/xbindkeys.desktop;
    home.file.".config/autostart/.polybar.desktop".source     = ../configs/startup/polybar.desktop;
    home.file.".config/mimeapps.list".source                  = ../configs/mimeapps.list;
    home.file.".xbindkeysrc".source                           = ../configs/.xbindkeysrc;
  };
}