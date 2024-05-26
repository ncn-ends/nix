packages : (packages // {
  # azure-cli = packages.azure-cli.override {
  #   python3 = packages.python310;
  # };
  polybar = packages.polybar.overrideAttrs (old: {
    version = "3.7.0";
    src = packages.fetchFromGitHub {
      owner = "polybar";
      repo = "polybar";
      rev = "3.7.0";
      hash = "sha256-Z1rL9WvEZHr5M03s9KCJ6O6rNuaK7PpwUDaatYuCocI=";
      fetchSubmodules = true;
    };
  });
  discord = packages.discord.overrideAttrs (old: {
    src = builtins.fetchTarball {
      url = "https://discord.com/api/download?platform=linux&format=tar.gz";
      sha256 = "1091nv1lwqlcs890vcil8frx6j87n4mig1xdrfxi606cxkfirfbh";
    };
  });
  nodejs = packages.nodejs.overrideAttrs (old: {
    version = "18.14.1";
  });
  # jetbrains.datagrip = packages.jetbrains.datagrip.overrideAttrs (old: rec {
  #   version = "2023.2.3";
  #   name = "datagrip-${version}";
  #   src = packages.fetchurl {
  #     url = "https://download.jetbrains.com/datagrip/datagrip-${version}.tar.gz";
  #     sha256 = "sha256-hlrUex5ZP2ac0mJTPoDc3WWL1cAp+l7SIEFapAf8LjU=";
  #   };
  # });
  # jetbrains.datagrip = packages.jetbrains.datagrip.overrideAttrs (old: rec {
  #   version = "2023.3.1";
  #   name = "datagrip-${version}";
  #   src = packages.fetchurl {
  #     url = "https://download.jetbrains.com/datagrip/datagrip-${version}.tar.gz";
  #     sha256 = "sha256-QXeILesDgPuptCbCWAuup9xCl73e/de/sJRDP/TLt7g=";
  #   };
  # });
  jetbrains.webstorm = packages.jetbrains.webstorm.overrideAttrs (old: rec {
    version = "2023.2.3";
    name = "webstorm-${version}";
    src = packages.fetchurl {
      url = "https://download.jetbrains.com/webstorm/WebStorm-${version}.tar.gz";
      sha256 = "sha256-tX9KcTYaIkrrDoDy8xH2MqsXVzVqLeNiet4+ndTuCJk=";
    };
  });
})