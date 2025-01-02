{
  inputs = {
    oldstable.url = "github:NixOS/nixpkgs/nixos-23.11";

    stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    untested.url = "github:NixOS/nixpkgs/master";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "stable";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "stable";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "stable";
  };

  outputs = inputs@{ self, darwin, home-manager, sops-nix, ... }:
    let
      lib = inputs.stable.lib;
      machines = {
        main = {
          hostName = "nixos";
          user = "one";
          nixConfigRoot = "/etc/nixos";
          system = "x86_64-linux";
        };
        macbook = {
          hostName = "ncns-MacBook-Pro";
          user = "ncn";
          nixConfigRoot = "/Users/ncn/nix2";
          system = "aarch64-darwin";
        };
      };
      drives = {
        shape = {
          location = "/mnt/shape";
        };
      };
      # takes all the unique systems from machines list
      supportedSystems = lib.lists.unique (builtins.map (machine: machine.system) (builtins.attrValues machines));

    in {
      devShells = import ./shells.nix {inherit inputs supportedSystems;};

      # TODO: these can be cleaned up a a bit more like the devShells one
      nixosConfigurations = builtins.listToAttrs (map (machine: let 
        system = machine.system;
        imports = import ./helpers/import-packages.nix { inherit system inputs;};
      in {
        name = machine.hostName;
        # each nixos system should be combined, similar to the empty attr set here
        value = import ./machine.main.nix {  inherit machines lib sops-nix imports drives home-manager; };
      }) [machines.main]);

      darwinConfigurations = builtins.listToAttrs (map (machine: let
        system = machine.system;
        imports = import ./helpers/import-packages.nix {inherit system inputs;};
      in {
        name = machine.hostName;
        value = import ./machine.macbook.nix { inherit system self darwin machine lib sops-nix imports drives home-manager; };
      }
      ) [machines.macbook]);

      # for testing. to see result do `nix eval .#eval
      eval = {
        "x86_64-linux" = lib.lists.unique (builtins.map (machine: machine.system) (builtins.attrValues machines));
      };
    };
}
