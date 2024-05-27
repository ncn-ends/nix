{mkShell, imports, ...}: 
mkShell rec { 
  name = "ncn-node-env-5";

  packages = [
    imports.stable.nodejs
    imports.stable.yarn
    # nodePackages.npm
    # nodePackages.pnpm
    # nodePackages.javascript-typescript-langserver
    # nodePackages.typescript
    # ngrok
    imports.overrides.jetbrains.webstorm
  ];
}