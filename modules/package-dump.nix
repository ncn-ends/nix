{ imports, ... }: 
let 
  stable = imports.stable;
  unstable = imports.unstable;
  untested = imports.untested;
  overrides = imports.overrides;
in {
  # every machine
  all = [
    stable.microsoft-edge
    stable.obs-studio
    stable.slack
    stable.firefox
  ];

  # every work machine
  work = [
    unstable.jetbrains.datagrip
    stable.insomnia
    stable.zoom-us
    unstable.azure-cli
    stable.gh
  ];

  # every personal machine
  personal = [
    overrides.discord 
    unstable.youtube-music
    stable.qbittorrent
    stable.libsForQt5.kdeconnect-kde
    stable.vlc
  ];
  
  # every linux personal machine
  personalLinux = [
    stable.whatsapp-for-linux
    stable.gimp
    stable.flameshot
    stable.libsForQt5.okular
    stable.imagemagick
    stable.libreoffice
    stable.libsForQt5.filelight
    stable.peek
    stable.shotcut
    stable.seafile-client
    stable.remmina
    stable.rclone
    stable.rclone-browser
  ];

  experimenting = [
    # untested.warp-terminal
  ];

  # to try:
  #     fzf
  #     tldr
  #     atuin
  #     grub-reboot
  #     Pcmanfm

  # to try again at some point maybe: 
  #     stacer
  #     floorp
}