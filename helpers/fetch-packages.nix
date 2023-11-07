{} : {
  unstable = import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) { config = { allowUnfree = true; }; };
  stable = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) { config = { allowUnfree = true; }; };
}