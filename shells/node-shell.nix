with import <nixpkgs> {};

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in mkShell {
  name = "node-env";
  packages = [
    nodejs-16_x
    nodePackages.npm
    nodePackages.yarn
    unstable.jetbrains.rider
  ];

  # shellHook = ''
  #   alias rider-open='rider '
  # '';
}