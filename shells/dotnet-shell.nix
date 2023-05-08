with import <nixpkgs> {};


let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in mkShell {
  name = "dotnet-env";
  packages = [
    dotnet-sdk_6
    jetbrains.rider
  ];

  shellHook = ''
    alias startrr='cd ~/code/2_rr/HCMServer; rider . &>/dev/null &'
  '';
}