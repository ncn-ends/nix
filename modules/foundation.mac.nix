{ stable, name, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${name} = { ... }: {
    home.username = name;
    programs.home-manager.enable = true;
    nixpkgs.config.allowUnfree = true;
  };
}