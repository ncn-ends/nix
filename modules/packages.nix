{ pkgs, config, services, ... }:
{
  # note: refer to home-manager set up file for more packages.
  # note: some packages are dependent on the desktop being used. they'll be included in the respective desktop files.

  environment.systemPackages = with pkgs; [
    wget
    playerctl # may help with vlc issues
  ];

  users.users.${config.lib.user.name}.packages =  with pkgs; [
    discord
    feh # used to apply desktop wallpaper
    xorg.xkill # kill program at mouse pointer location
    qbittorrent
    flameshot # screenshot tool
    bpytop # system monitor
    libsForQt5.konsole # terminal emulator
  ];

  programs.steam.enable = true;
  programs.gamemode.enable = true;
  virtualisation.docker.enable = true;

  xdg.portal.enable = true; # required for flatpak
  services.flatpak.enable = true;
  # flatpak packages: flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  #   - vlc

  # services.plex = {
  #   enable = true;
  #   openFirewall = true;
  # };

  # services.jellyfin.enable = true;

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