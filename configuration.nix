{ config, pkgs, ... }:

let 
  user = "one";
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  system.stateVersion = "21.11"; # DO NOT CHANGE
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];
  nixpkgs.config.allowUnfree = true;

  # --- FOUNDATION --- 
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true; # detects other linux boot partitions
  boot.kernelPackages = pkgs.linuxPackages_latest; # recommended, not sure
  boot.initrd.kernelModules = ["amdgpu"]; # recommended, not sure
  boot.loader.grub.device = "/dev/sda";
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     useXkbConfig = true; # use xkbOptions in tty.
  };
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # --- DESKTOP ENVIRONMENT ---
  # with cinnamon
  services.xserver = {
    enable = true;
    libinput.enable = true;
    displayManager.lightdm.enable = true;
    displayManager.defaultSession = "cinnamon";
    desktopManager.cinnamon.enable = true;
  };
  # manual settings
  #   - shortcuts
  #       - rofi
  #       - flameshot

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

  # --- PACKAGES ---
  environment.systemPackages = with pkgs; [
    vim
    wget
    # dotnetCorePackages.sdk_6_0
    # msbuild
    # netcoredbg
    # omnisharp-roslyn
    # mono
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
      qbittorrent
      flameshot # screenshot tool
    ];
  };
  programs.steam.enable = true;

  # environment.sessionVariables = {
  #   DOTNET_ROOT = "${pkgs.dotnet-sdk}";
  #   DOTNET_CLI_TELEMETRY_OPTOUT = "true";
  # };

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

    home.packages = [ 
      pkgs.neofetch 
      pkgs.jetbrains.rider # by default has 2022.2 which is too old
      pkgs.jetbrains.datagrip # see prev
      pkgs.microsoft-edge
      pkgs.slack
      pkgs.insomnia
      pkgs.zoom-us
      pkgs.libsForQt5.okular
      pkgs.obs-studio
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
      # don't modal opening on goto, just go to
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
#   - update action bar
#   - import datagrip/rider settings
#       - connect datagrip to database
#   - setup insomnia syncing
#   - rofi themes
#       - https://github.com/adi1090x/rofi
#       - https://www.reddit.com/r/unixporn/comments/wndrz1/oc_rofi_a_bunch_of_rofi_themes_for_you_all_choose/
#   - configure okular theme
#   - figure out why linux mint boot doesn't show up in the boot loader
#   - set up web dev environment
#   - set up mobile dev environment
#   - confiz
#   - sops-nix to manage ssh keys
#   - make cinnamon tiling
#   -   only option is gtile, not worth hassle
#   - figure out why gamemode always asks for password
#   - terminal based file explorer