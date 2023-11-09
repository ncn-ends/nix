{ stable, unstable, config, services, name, ... }:
{
  environment.systemPackages = with stable; [
    wget
    lutris
  ];

  users.users.${name}.packages =  with stable; [
    discord
    # feh # used to apply desktop wallpaper, useful for certain DEs
    xorg.xkill # kill program at mouse pointer location
    qbittorrent
    flameshot # screenshot tool
  ];

  programs.steam.enable = true;
  programs.gamemode.enable = true;
  virtualisation.docker.enable = true;

  xdg.portal.enable = true; # required for flatpak
  services.flatpak.enable = true;
  # flatpak packages: flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  #   - vlc

  # TODO: this is fine for now, but should move overlays into 1 file when there are too many
  nixpkgs.overlays = [
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
        }; }
      );
    })
  ];
}