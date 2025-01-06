{darwin, system, self, machine, imports, home-manager, ...} : 
darwin.lib.darwinSystem {
  inherit system;
  specialArgs = {
    inherit self machine imports;
    name = machine.user;
    unstable = imports.unstable;
    stable = imports.stable;
  };
  modules = [
    home-manager.darwinModules.home-manager
    ./modules/foundation.nix
    ./modules/foundation.macbook.nix
    ./modules/cli.nix
    ./modules/vscode.nix
  ];
}