with import <nixpkgs> {};


let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in mkShell {
  name = "dotnet-env";
  packages = [
    dotnet-sdk_6
    jetbrains.rider
  ];

  shellHook = import ./shellHook.nix;
}