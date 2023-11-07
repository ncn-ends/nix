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