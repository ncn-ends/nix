{
  description = "A very basic flake";

  # inputs are like nix channels that are going to be used to build the system
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    lib = nixpkgs.lib;
  in {
    nixosConfiguration = {
      one = lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix ]
      }
    };
  };
  
}
