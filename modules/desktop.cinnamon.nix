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
    extraPackages = [
      stable.amdvlk
      stable.vaapiVdpau
      stable.libvdpau-va-gl
    ];
  };

  home-manager.users.${name} = { ... }: {
    programs.rofi = {
      enable = true;
      theme = ../configs/rofi/theme.rasi;
      plugins = [
        stable.rofi-calc
      ];
      extraConfig =  {
        modi = "window,drun,run,ssh,calc";
      };
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
      stable.xorg.xkill
    ];

    home.file.".config/autostart/.screenkey.desktop".source   = ../configs/startup/screenkey.desktop;
    home.file.".config/autostart/.flameshot.desktop".source   = ../configs/startup/flameshot.desktop;
    home.file.".config/autostart/.xbindkeys.desktop".source   = ../configs/startup/xbindkeys.desktop;
    home.file.".config/autostart/.polybar.desktop".source     = ../configs/startup/polybar.desktop;
    home.file.".config/mimeapps.list".source                  = ../configs/xorg/mimeapps.list;
    home.file.".xbindkeysrc".source                           = ../configs/xorg/.xbindkeysrc;
  };
}