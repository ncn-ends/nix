with (import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) {});
mkShell {
  name = "node-env";
  packages = [
    nodejs
    nodePackages.npm
    nodePackages.yarn
    nodePackages.javascript-typescript-langserver
    nodePackages.typescript
    jetbrains.rider
    jetbrains.webstorm
  ];
  shellHook = import ./shellHook.nix;
}