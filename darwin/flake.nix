{
	description = "ncn macos flake";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
		nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
		nixpkgs-unstable.inputs.nixpkgs.follows = "nixpkgs";
		home-manager.url = "github:nix-community/home-manager/master";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		darwin.url = "github:LnL7/nix-darwin";
		darwin.inputs.nixpkgs.follows = "nixpkgs";
	}; 
	outputs = inputs@{nixpkgs, nixpkgs-unstable, home-manager, darwin, ...}: 
	{
		darwinConfigurations.ncn-2 = darwin.lib.darwinSystem {
			system = "aarch64-darwin";
			modules = [
				{ nixpkgs.config.allowUnfree = true; }
				../modules/darwin.nix
				home-manager.darwinModules.home-manager {
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						# extraSpecialArgs = { inherit pwnvim; }; then define the args in the modules file as an param
						users.ncn.imports = [
							../modules/home/work.nix
						];
					};
				}
			];
		};
	};
}