{stable, unstable, name}: 
{
  # every machine
  all = [
    unstable.microsoft-edge
    stable.obs-studio
    stable.slack
    stable.firefox
  ];

  # every work machine
  work = [
    stable.jetbrains.datagrip
    stable.insomnia
    stable.zoom-us
    stable.azure-cli
  ];

  # every personal machine
  personal = [
    stable.discord 
    unstable.youtube-music
    stable.qbittorrent
    stable.libsForQt5.kdeconnect-kde
    unstable.vlc
  ];
  
  # every linux personal machine
  personalLinux = [
    stable.whatsapp-for-linux
    stable.xfce.thunar
    stable.gimp
    stable.flameshot
    stable.libsForQt5.okular
    stable.imagemagick
    stable.libreoffice
    stable.libsForQt5.filelight
    stable.peek
    stable.shotcut
    stable.seafile-client
  ];

  # to try:
  #     fzf
  #     tldr
  #     atuin
  #     grub-reboot

  # to try again at some point maybe: 
  #     stacer
  #     floorp
}
