{mkShell, stable, unstable, ...}: 
mkShell rec { 
  name = "ncn-node-env-4";

  packages = let 
    inherit (stable) 
    nodejs 
    # nodePackages 
    # ngrok 
    # jetbrains 
    yarn;
  in [
    nodejs
    yarn
    # nodePackages.npm
    # nodePackages.pnpm
    # nodePackages.javascript-typescript-langserver
    # nodePackages.typescript
    # ngrok
    stable.jetbrains.webstorm
  ];
}