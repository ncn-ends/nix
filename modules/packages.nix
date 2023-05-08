{ pkgs, config, services, ... }:
{
  # note: refer to home-manager set up file for more packages.
  # note: some packages are dependent on the desktop being used. they'll be included in the respective desktop files.

  environment.systemPackages = with pkgs; [
    vim
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