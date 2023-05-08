with import <nixpkgs> {};


with (import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) {});
mkShell {
  name = "ios-env";
  buildInputs = [
    nodejs
    nodePackages.npm
    nodePackages.yarn
    cocoapods
  ];

  # sudo xcode-select --switch /Applications/Xcode.app
  # sudo xcodebuild -license

  # sed: can't read s/\@ac_cv_have_libgflags\@/0/: No such file or directory
  #   - tried doing xcodeselect again
  #   - sudo pod install
  #       - can't run as root
  #   - unset LDFLAGS and CPPFLAGS environment variables
  #   - other env variables unset
  #   - get rid of coreutils
}