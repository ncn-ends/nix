
{ pkgs, services, config, ... }:
let 
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  home-manager.users.${config.lib.user.name} = { pkgs, ... }: {
    imports = [
      ./default.nix
    ];
    home.packages = [
      pkgs.neofetch 
      pkgs.libsForQt5.okular
      pkgs.xbindkeys
      pkgs.libreoffice
      pkgs.peek
      pkgs.psensor
      pkgs.imagemagick
      pkgs.tokei
    ];

    programs.rofi = {
      enable = true;
      theme = ../../configs/rofi/theme.rasi;
    };
    services.polybar = {
      enable = true;
      script = "polybar bar &";
    };
    programs.emacs = {
      enable = true;
      package = pkgs.emacs;
    };

    home.file.".config/qtile/config.py".source              = ../../configs/qtile.py;
    home.file.".xbindkeysrc".source                         = ../../configs/.xbindkeysrc;
    home.file.".config/autostart/.flameshot.desktop".source = ../../configs/desktop-entries/flameshot.desktop;
    home.file.".config/autostart/.xbindkeys.desktop".source = ../../configs/desktop-entries/xbindkeys.desktop;
    home.file.".config/autostart/.polybar.desktop".source   = ../../configs/desktop-entries/polybar.desktop;
    home.file.".config/mimeapps.list".source                = ../../configs/mimeapps.list;
    home.file.".ideavimrc".source                           = ../../configs/.ideavimrc;
    home.file.".config/emacs".source                        = ../../configs/emacs;
  };
}