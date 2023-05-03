{ pkgs, services, config, ... }:
let 
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  home.packages = [ 
    pkgs.neofetch 
    unstable.jetbrains.datagrip # by default has 2022.2 which is too old
    pkgs.microsoft-edge
    pkgs.slack
    pkgs.insomnia
    pkgs.zoom-us
    pkgs.libsForQt5.okular
    pkgs.obs-studio
    pkgs.firefox
    pkgs.xbindkeys
    pkgs.vlc
    pkgs.alacritty
  ];
}