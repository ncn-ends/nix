{...} : 
{
  unstable = import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) { config = { allowUnfree = true; }; };
  stable = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) { config = { allowUnfree = true; }; };
  home-manager = fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz;
}