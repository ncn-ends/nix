{ stable, unstable, config, services, name, ... }:
{
  users.users.${name}.packages = with stable; [
    discord 
    stable.xorg.xkill
  ];

  home-manager.users.${name} = { ... }: {
    home.packages = [ 
      stable.libsForQt5.okular
      stable.libreoffice
      stable.imagemagick
      stable.krusader
      stable.gimp
      stable.libsForQt5.kdeconnect-kde
      unstable.youtube-music
      stable.flameshot
      stable.qbittorrent
      unstable.vlc
      stable.libsForQt5.filelight
    ];
  };
}