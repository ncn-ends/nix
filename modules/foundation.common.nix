{ stable, name, ... }:
{
  home-manager.users.${name} = { ... }: {
    home.stateVersion = "22.11";
    nixpkgs.config.allowUnfree = true;
  };

  environment.systemPackages = [
    stable.python3
  ];
}