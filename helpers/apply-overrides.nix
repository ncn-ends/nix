packages : (packages // {
  azure-cli = packages.azure-cli.override {
    python3 = packages.python310;
  };
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
})