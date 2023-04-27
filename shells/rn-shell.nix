with import <nixpkgs> {};

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in mkShell {
  name = "rn-env";
  packages = [
    nodejs
    nodePackages.npm
    nodePackages.yarn
    unstable.jetbrains.rider
    android-studio
    watchman
  ];
}