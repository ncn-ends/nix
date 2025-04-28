{ imports, ... }: 
let 
  stable = imports.stable;
  unstable = imports.unstable;
  untested = imports.untested;
  overrides = imports.overrides;
  lib = imports.stable.lib;
in {
  # every machine
  all = [
    unstable.microsoft-edge
    stable.obs-studio
    stable.firefox
    unstable.obsidian
  ];

  # every work machine
  work = [
    unstable.jetbrains.datagrip
    stable.slack
    stable.insomnia
    stable.zoom-us
    unstable.azure-cli
    # unstable.azure-functions-core-tools
    stable.gh
  ];

  # every personal machine
  personal = [
    overrides.discord 
    stable.youtube-music
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
    stable.qimgv
  ];

  experimenting = [
    # untested.warp-terminal
    # stable.wireshark
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