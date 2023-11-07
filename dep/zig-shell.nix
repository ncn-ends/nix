with (import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) { config = {allowUnfree = true;}; });
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cmake
    gdb
    libxml2
    ninja
    qemu
    wasmtime
    zlib
    zig
  ] ++ (with llvmPackages_14; [
    clang
    clang-unwrapped
    lld
    llvm
  ]);

  hardeningDisable = [ "all" ];
}