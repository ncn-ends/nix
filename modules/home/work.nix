
{ pkgs, services, config, ... }:
let 
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  imports = [
    ./default.nix
  ];
}