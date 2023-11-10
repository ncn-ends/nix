{ stable, unstable, config, services, name, ... }:
{

  # TODO: should use override instead of overlay
  users.users.${name}.packages = with stable; [
    discord 
    stable.xorg.xkill
  ];
  nixpkgs.overlays = [
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
        }; }
      );
    })
  ];
  home-manager.users.${name} = { ... }: {
    home.packages = [ 
      stable.libsForQt5.okular
      stable.libreoffice
      stable.imagemagick
      stable.libsForQt5.dolphin
      stable.gimp
      stable.libsForQt5.kdeconnect-kde
      stable.youtube-music
      stable.flameshot
      stable.qbittorrent
      unstable.vlc
    ];
  };
}