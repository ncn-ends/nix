{ config, ... }:
let 
  home-manager = fetchTarball https://github.com/nix-community/home-manager/archive/release-22.11.tar.gz;
in {
  system.stateVersion = "21.11"; # DO NOT CHANGE
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  imports = [ 
    ./modules/hardware-configuration.nix
    "${home-manager}/nixos"
    # <home-manager/nixos>
    ./modules/foundation.nix
    ./modules/cinnamon.desktop.nix
    ./modules/users.nix
    ./modules/packages.nix
    ./modules/home.nix
  ];
}