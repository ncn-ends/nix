with (import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) { config = { allowUnfree = true;}; });
mkShell {
  name = "dotnet-env";
  packages = [
    dotnet-sdk_6
    (jetbrains.rider.overrideAttrs (old: {
      postPatch = old.postPatch + ''
        interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
        patchelf --set-interpreter $interp plugins/dotCommon/DotFiles/linux-x64/JetBrains.Profiler.PdbServer
      '';
    }))
  ];

  shellHook = import ./shellHook.nix;
}