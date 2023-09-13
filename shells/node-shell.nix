with (import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) {});
let 
  NPM_CONFIG_PREFIX = toString ./npm_config_prefix;
in mkShell {
  name = "node-env";
  packages = [
    git
    openssh
    nodejs
    nodePackages.npm
    nodePackages.yarn
    nodePackages.pnpm
    nodePackages.javascript-typescript-langserver
    nodePackages.typescript
    jetbrains.rider
    jetbrains.webstorm
    ngrok
  ];
  NPM_CONFIG_PREFIX = toString ./npm_config_prefix;
  # shellHook = import ./shellHook.nix;
  shellHook = (import ./shellHook.nix) + ''
    export PATH="${NPM_CONFIG_PREFIX}/bin:$PATH"
  '';
}