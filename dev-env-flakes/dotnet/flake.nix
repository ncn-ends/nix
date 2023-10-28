{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils"; # new input
  };
  outputs = {self, nixpkgs, flake-utils}: # need to pull it in to use it
    flake-utils.lib.eachDefaultSystem (system: # it's a function that gives us access to the system
      let 
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.${system}.default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs
          ];
        };
      }
    );
}