with import <nixpkgs> {};


with (import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) {});
mkShell {
  name = "ios-env";
  buildInputs = [
    nodePackages.npm
    nodePackages.yarn
    cocoapods
    (runCommandLocal "sed" {} ''
      mkdir -p $out/bin
      ln -vs /usr/bin/sed $out/bin/sed
    '')
  ];

  # shellHook = ''
  #   export PATH="${}
  # '';

  # sudo xcode-select --switch /Applications/Xcode.app
  # sudo xcodebuild -license
}