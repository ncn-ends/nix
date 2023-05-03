{ pkgs, config, services, ... }:
{
  lib = {
    user = {
      name = "one";
      realName = "ncn";
    };
    unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  };
}