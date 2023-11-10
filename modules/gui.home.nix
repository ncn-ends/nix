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
      # stable.libsForQt5.dolphin
      stable.krusader
      stable.gimp
      stable.libsForQt5.kdeconnect-kde
      stable.youtube-music
      stable.flameshot
      stable.qbittorrent
      unstable.vlc
    ];
  };
}