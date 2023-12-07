{mkShell, stable, unstable, ...}: 
mkShell rec { 
  name = "ncn-node-env";

  stablePackages = with stable; [
    nodejs
    nodePackages.npm
    nodePackages.yarn
    nodePackages.pnpm
    nodePackages.javascript-typescript-langserver
    nodePackages.typescript
    ngrok
  ];

  unstablePackages = with unstable; [
    jetbrains.rider
    jetbrains.webstorm
  ];

  packages = stablePackages ++ unstablePackages;
}
