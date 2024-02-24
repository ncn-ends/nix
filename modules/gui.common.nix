{ stable, unstable, config, services, name, ... }:
{
  home-manager.users.${name} = { ... }: {
    home.packages = [ 
      stable.jetbrains.datagrip
      unstable.microsoft-edge
      stable.slack
      stable.insomnia
      stable.zoom-us
      stable.obs-studio
      stable.firefox
      stable.azure-cli
      stable.peek
      stable.shotcut
      stable.seafile-client
    ];

    programs.alacritty = {
      enable = true;
      settings.window = {
        opacity = 0.95;
        dimensions = {
          lines = 40;
          columns = 120;
        };
      };
    };
  };
}