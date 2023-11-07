
with (import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) { config = { allowUnfree = true; android_sdk.accept_license = true; }; });

androidenv.emulateApp {
  name = "Pixel_4_API_33";
  platformVersion = "33";
  abiVersion = "x86";
  avdHomeDir = "$HOME";
  systemImageType = "default";
}