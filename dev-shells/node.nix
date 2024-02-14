{mkShell, stable, unstable, ...}: 
mkShell rec { 
  name = "ncn-node-env";

  packages = let 
    inherit (stable) nodejs nodePackages ngrok;
    inherit (unstable) jetbrains;
  in [
    nodejs
    nodePackages.npm
    nodePackages.yarn
    nodePackages.pnpm
    nodePackages.javascript-typescript-langserver
    nodePackages.typescript
    ngrok
    jetbrains.webstorm
  ];
}
