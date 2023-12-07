{mkShell, stable, unstable, ...}: 
mkShell rec {
  name = "ncn-python-env";
  python = stable.python310;
  patchShebangs = true;
  packages = with stable.python310.pkgs; [
    ipython
    pip
    setuptools
    virtualenvwrapper
    wheel

    stable.libffi
    stable.openssl
    stable.gcc
    stable.unzip

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
    # requests

    stable.jetbrains.pycharm-professional
  ];
  shellHook = ''
    VENV=.venv
    if test ! -d $VENV; then
      virtualenv $VENV
    fi
    source ./$VENV/bin/activate
    export PYTHONPATH=`pwd`/$VENV/${python.sitePackages}/:$PYTHONPATH
  '';
}