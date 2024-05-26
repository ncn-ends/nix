{mkShell, stable, unstable, overrides, ...}: 
mkShell rec { 
  name = "ncn-node-env-5";

  packages = [
    overrides.nodejs
    stable.yarn
    # nodePackages.npm
    # nodePackages.pnpm
    # nodePackages.javascript-typescript-langserver
    # nodePackages.typescript
    # ngrok
    overrides.jetbrains.webstorm
  ];
}