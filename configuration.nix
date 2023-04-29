{ config, pkgs, ... }:

let 
  user = "one";
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  system.stateVersion = "21.11"; # DO NOT CHANGE
  imports =
    [ 
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];
  nixpkgs.config.allowUnfree = true;

  # --- FOUNDATION --- 
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true; 
  boot.kernelPackages = pkgs.linuxPackages_latest; 
  boot.initrd.kernelModules = ["amdgpu"]; 
  boot.loader.grub.device = "/dev/sda";
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     useXkbConfig = true;
  };
  sound.enable = true;
  hardware.pulseaudio.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
      ];
      wlr = {
        enable = true;
      };
    }; # required for wlroots based desktops


  # --- PACKAGES ---
  environment.systemPackages = with pkgs; [
    vim
    wget
    wayfire 
    wlr-randr # get output of monitors on wayland
  ];

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner" ];
    initialPassword = "password";
    packages = with pkgs; [
      discord
      feh # used to apply desktop wallpaper
      xorg.xkill # kill program at mouse pointer location
      qbittorrent
      flameshot # screenshot tool
      bpytop # system monitor
      libsForQt5.konsole # terminal emulator
    ];
  };
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

  # home-manager
  home-manager.users.${user} = { pkgs, ... }: {
    home.stateVersion = "22.11"; # DO NOT CHANGE
    nixpkgs.config.allowUnfree = true;

    home.file.".bashrc".source = ./configs/.bashrc;
    home.file.".vimrc".source = ./configs/.vimrc;
    # home.file.".config/wayfire.ini".source = ./configs/wayfire.ini;
    # home.file.".xbindkeysrc".source = ./configs/.xbindkeysrc;
    # home.file.".config/autostart/.flameshot.desktop".source = ./configs/desktop-entries/flameshot.desktop;
    # home.file.".config/autostart/.xbindkeys.desktop".source = ./configs/desktop-entries/xbindkeys.desktop;
    # home.file.".config/mimeapps.list".source = ./configs/mimeapps.list;


    home.packages = [ 
      pkgs.neofetch 
      # unstable.jetbrains.datagrip # by default has 2022.2 which is too old
      pkgs.microsoft-edge
      pkgs.slack
      pkgs.insomnia
      pkgs.zoom-us
      pkgs.libsForQt5.okular
      pkgs.obs-studio
      pkgs.firefox
      pkgs.xbindkeys
      pkgs.vlc
      pkgs.alacritty
    ];
    programs.rofi = {
      enable = true;
      theme = ./configs/rofi/theme.rasi;
    };
    

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

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        bbenoist.nix
        jnoortheen.nix-ide
        formulahendry.auto-rename-tag
        formulahendry.auto-close-tag
        dbaeumer.vscode-eslint
        eamodio.gitlens
        esbenp.prettier-vscode 
      ];
    };

    programs.vscode.userSettings = {
      "vim.useSystemClipboard" = true;
      "workbench.editor.wrapTabs" = true; # tabs become multiline instead of scroll
      "emmet.showExpandedAbbreviation" = "never"; # emmet gets in the way

      # don't open modal on goto, just go to
      "editor.gotoLocation.multipleTypeDefinitions" = "goto";
      "editor.gotoLocation.multipleImplementations" = "goto";
      "editor.gotoLocation.multipleDefinitions" = "goto";
      "editor.gotoLocation.multipleDeclarations" = "goto";

      "vim.normalModeKeyBindings" = [
        {
          "before" =  ["g" "r"];
          "commands" = [ "editor.action.goToReferences" ];
        }
      ];

      "vim.handleKeys" = {
        "<C-f>" =  false;
        "<C-x>" =  false;
      };

      "[typescriptreact]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[javascript]" =  {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
    };
  };

}

# TODO:
#   - music player app, connects to youtube music
#   - set up datagrip
#   - import datagrip/rider settings
#       - connect datagrip to database
#   - setup insomnia syncing
#   - configure okular theme
#   - figure out why linux mint boot doesn't show up in the boot loader
#   - set up mobile dev environment
#   - compiz
#   - sops-nix to manage ssh keys
#   - make cinnamon tiling
#   -   only option is gtile, not worth hassle
#   - figure out why gamemode always asks for password
#   - terminal based file explorer
#   - learn about flakes
#   - customize terminal
#   - make vim ignore caps lock
#   - virtManager / windows VM
#   - customize firefox
#   - customize polybar

# Desktop compositor (Xorg)
#     - xserver
# Notification daemon
# Display manager
# Screen locker
# Application launcher
#     - rofi
# Audio control
# Backlight control
# Media control
# Polkit authentication agent
# Power management
# Screen capture
#     - flameshot
# Screen temperature
# Wallpaper setter
#     - feh
# Logout dialogue
# Default applications
#   see: https://wiki.gentoo.org/wiki/Default_applications
# Topbar
# question
#   - change topbar



# interesting things
#   - https://github.com/hyprwm/Hyprland

# bad programs
#   - sxhkd
#       - horrible name
#       - no place in documentation to see keys, have to use a separate program (unlike xbindkeys)
#       - using xev to find some keys (fn keys, print screen, etc) doesn't work sometimes due to other programs getting in the way, so you have to create a clean instance of xorg to test the keys you want to bind
#       - doesn't support key codes, just key names
