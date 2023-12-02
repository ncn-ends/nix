{ stable, unstable, config, services, name, ... }:
{
  home-manager.users.${name} = { ... }: {
    home.packages = [ 
      unstable.jetbrains.datagrip
      unstable.microsoft-edge
      stable.slack
      stable.insomnia
      stable.zoom-us
      stable.obs-studio
      stable.firefox
      stable.alacritty
      stable.azure-cli
      stable.peek
      stable.shotcut
    ];

    programs.alacritty = {
      enable = true;
      settings.window = {
        opacity = 0.95;
        dimensions = {
          lines = 40;
          columns = 150;
        };
      };
    };
  };
}