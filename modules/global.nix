{ config, services, ... }:
{
  lib = {
    user = {
      name = "one";
      realName = "ncn";
    };
    basePath = {
      linux = /etc/nixos; # TODO: incorporate these into the paths instead of relative paths
      mac = ~/nix;
    };
  };
}