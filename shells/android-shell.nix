# with import <nixpkgs> {};

# let
#   unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
# in mkShell {
#   name = "rn-env";
#   packages = [
#     nodejs
#     nodePackages.npm
#     nodePackages.yarn
#     unstable.jetbrains.rider
#     unstable.android-studio
#     watchman
#   ];

#   shellHook = ''
    

#     echo "Mobile shell starting..."
#   '';
# }


# todo: 
#   - automate the creation of the repo directory. if it doesn't exist yet, clone it
{ pkgs ? import <nixpkgs> {
  config.android_sdk.accept_license = true;
  config.allowUnfree = true;
} }:

with pkgs;

let
  android-nixpkgs = callPackage (import (builtins.fetchGit {
    url = "https://github.com/tadfisher/android-nixpkgs.git";
  })) {
    # Default; can also choose "beta", "preview", or "canary".
    channel = "stable";
  };
  android-sdk = android-nixpkgs.sdk (sdkPkgs: with sdkPkgs; [
    cmdline-tools-latest
    # build-tools-30-0-0
    # platform-tools
    # platforms-android-31
    # emulator
  ]);
in
mkShell {
  buildInputs = [
    android-sdk
    android-studio
    nodejs
    yarn
    jetbrains.rider
  ];
}