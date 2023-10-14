with (import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) { config = { allowUnfree = true;}; });
let 
in mkShell {
  name = "bun-env";
  packages = [
    git
    openssh
    bun
    jetbrains.rider
    jetbrains.webstorm
    ngrok
  ];
}