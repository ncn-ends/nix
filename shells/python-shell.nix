with (import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) {allowUnfree = true;});
let 
  pythonEnv = python310.withPackages (ps: [
    ps.fastapi
    ps.uvicorn
    ps.httpx
    ps.pytest
    ps.websockets
  ]);
in mkShell {
  name = "python-shell";
  packages = [
    jetbrains.pycharm-professional
    pythonEnv
  ];
  shellHook = (import ./shellHook.nix) + ''
    alias py:dev="uvicorn main:app --reload"
  '';
}