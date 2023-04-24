{ config, pkgs, ... }:

let 
  user = "one";
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  nixpkgs.config.allowUnfree = true;

  # --- foundational system config
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true; # detects other linux boot partitions
  boot.kernelPackages = pkgs.linuxPackages_latest; # recommended, not sure
  boot.initrd.kernelModules = ["amdgpu"]; # recommended, not sure
  boot.loader.grub.device = "/dev/sda";
  time.timeZone = "America/Los_Angeles";
  # may need to set this: time.hardwareClockInLocalTime = true;
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     useXkbConfig = true; # use xkbOptions in tty.
  };

  # with cinnamon
  services.xserver = {
    enable = true;
    libinput.enable = true;
    displayManager.lightdm.enable = true;
    displayManager.defaultSession = "cinnamon";
    desktopManager.cinnamon.enable = true;
  };

  # with i3
  # services.xserver.enable = true;
  # services.xserver.desktopManager.xterm.enable = false;
  # services.xserver.displayManager.defaultSession = "none+i3";
  # services.xserver.windowManager.i3 = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     dmenu # application launcher most people use
  #     i3status # gives you the default i3 status bar
  #     i3lock # default i3 screen locker
  #     i3blocks # if you are planning on using i3blocks over i3status
  #   ];
  # };



  # with KDE
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  
  # these didn't work too well
  # services.xserver.displayManager.lightdm.enable = true; # check into other display managers, lightdm was recommended
  # services.xserver.windowManager.bspwm.enable = true;
  # services.xserver.displayManager.defaultSession = "none+bspwm";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # --- PACKAGES ---
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner" ];
    initialPassword = "password";
    packages = with pkgs; [
      discord
      feh # used to apply desktop wallpaper in i3
      xorg.xkill # kill program at mouse pointer location
      gamemode
    ];
  };
  programs.steam.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment? 

  nixpkgs.overlays = [
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
        }; }
      );
    })
  ];

  # home-manager
  home-manager.users.${user} = { pkgs, ... }: {
    home.stateVersion = "22.11";
    nixpkgs.config.allowUnfree = true;

    home.packages = [ 
      pkgs.vscode
      pkgs.neofetch 
      unstable.jetbrains.rider # by default has 2022.2 which is too old
      unstable.jetbrains.datagrip # see prev
      pkgs.microsoft-edge
      pkgs.slack
      pkgs.insomnia
      pkgs.zoom-us
      pkgs.qbittorrent
      pkgs.libsForQt5.okular
      pkgs.gamemode
      pkgs.dotnet-sdk_7
    ];

    programs.rofi.enable = true;

    programs.git = {
      enable = true;
      extraConfig = {
        url = {
          "git@github.com:" = {
            insteadOf = "https://github.com/";
          };
        };
      };
    };
  };

}

# TODO:
#   - music player app, connects to youtube music
#   - update action bar
#   - import datagrip/rider settings
#       - connect datagrip to database
#   - setup git/ssh
#   - setup insomnia syncing
#   - rofi themes
#       - https://github.com/adi1090x/rofi
#       - https://www.reddit.com/r/unixporn/comments/wndrz1/oc_rofi_a_bunch_of_rofi_themes_for_you_all_choose/
#   - configure okular theme
#   - figure out why linux mint boot doesn't show up in the boot loader
#   - install dotnet
#   - try out web ui
#   - set up mobile dev environment
#   - test out gamemode/proton on game
#   - screenshot software
#   - file explorer software
#   - confiz
#   - sops-nix to manage ssh keys
