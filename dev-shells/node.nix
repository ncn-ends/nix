{mkShell, stable, unstable, ...}: 
mkShell rec { 
  name = "ncn-node-env";

  packages = let 
    inherit (stable) nodejs nodePackages ngrok jetbrains;
    # inherit (stable) jetbrains;
  in [
    nodejs
    nodePackages.npm
    nodePackages.yarn
    nodePackages.pnpm
    nodePackages.javascript-typescript-langserver
    nodePackages.typescript
    ngrok
    stable.jetbrains.webstorm
  ];
}