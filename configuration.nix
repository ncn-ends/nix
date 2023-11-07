{ config, ... }:
{
  system.stateVersion = "21.11"; # DO NOT CHANGE
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  imports = [ 
    ./modules/hardware-configuration.nix
    <home-manager/nixos>
    ./modules/global.nix
    ./modules/foundation.nix
    ./modules/cinnamon.desktop.nix
    ./modules/users.nix
    ./modules/packages.nix
    ./modules/home.nix
  ];
  nixpkgs.config.allowUnfree = true;
}

# TODO:
#   - music player app, connects to youtube music
#   - configure okular theme
#   - figure out why linux mint boot doesn't show up in the boot loader
#   - set up mobile dev environment
#   - compiz
#   - sops-nix to manage ssh keys
#   - make cinnamon tiling
#   -   only option is gtile, not worth hassle
#   - figure out why gamemode always asks for password
#   - terminal based file explorer
#   - learn about flakes
#   - customize terminal
#   - make vim ignore caps lock
#   - virtManager / windows VM

# Desktop compositor (Xorg)
#     - xserver
# Notification daemon
# Display manager
# Screen locker
# Application launcher
#     - rofi
# Audio control
# Backlight control
# Media control
# Polkit authentication agent
# Power management
# Screen capture
#     - flameshot
# Screen temperature
# Wallpaper setter
#     - feh
# Logout dialogue
# Default applications
#   see: https://wiki.gentoo.org/wiki/Default_applications
# Topbar
# question
#   - change topbar



# interesting things
#   - https://github.com/hyprwm/Hyprland

# bad programs
#   - sxhkd
#       - horrible name
#       - no place in documentation to see keys, have to use a separate program (unlike xbindkeys)
#       - using xev to find some keys (fn keys, print screen, etc) doesn't work sometimes due to other programs getting in the way, so you have to create a clean instance of xorg to test the keys you want to bind
#       - doesn't support key codes, just key names
