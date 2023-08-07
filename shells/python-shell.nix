with (import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) { config = { allowUnfree = true;}; });
let
  python = pkgs.python310;
in
mkShell {
  name = "pip-env";
  patchShebangs = true;
  packages = with python.pkgs; [
    ipython
    pip
    setuptools
    virtualenvwrapper
    wheel

    libffi
    openssl
    gcc
    unzip

    # pip libraries
    # fastapi
    # uvicorn
    # httpx
    # pytest
    # pytest-asyncio
    # websockets
    # python-dotenv
    # aiohttp
    # python-multipart
    requests

    jetbrains.pycharm-professional
  ];
  shellHook = ''
    alias pycharm="pycharm-professional . &>/dev/null &"

    VENV=.venv
    if test ! -d $VENV; then
      virtualenv $VENV
    fi
    source ./$VENV/bin/activate
    export PYTHONPATH=`pwd`/$VENV/${python.sitePackages}/:$PYTHONPATH

    echo "Starting python environment.

    Shortcuts:
        pycharm         =  opens pycharm in the current directory
    "
  '';
}
