
{ pkgs, services, config, ... }:
let 
  unstable = import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) { config = { allowUnfree = true; }; };
in {
  home-manager.users.${config.lib.user.name} = { pkgs, ... }: {
    home.stateVersion = "22.11"; # DO NOT CHANGE
    nixpkgs.config.allowUnfree = true;

    home.packages = [ 
      # default
      unstable.jetbrains.datagrip # by default has 2022.2 which is too old
      unstable.microsoft-edge
      pkgs.slack
      pkgs.insomnia
      pkgs.zoom-us
      pkgs.obs-studio
      pkgs.firefox
      # unstable.vlc
      pkgs.alacritty
      pkgs.azure-cli
      pkgs.figma-linux
      pkgs.drawio
    
      # home only
      pkgs.neofetch 
      pkgs.libsForQt5.okular
      pkgs.xbindkeys
      pkgs.libreoffice
      pkgs.peek
      pkgs.psensor
      pkgs.imagemagick
      pkgs.tokei
      pkgs.speedtest-cli
      pkgs.shotcut
      pkgs.krusader
      pkgs.libsForQt5.dolphin
      pkgs.bottom
      pkgs.gimp
      pkgs.gitkraken
      pkgs.libsForQt5.kdeconnect-kde
    ];

    programs.vim = {
      enable = true;
      defaultEditor = true;
    };

    programs.bash = {
      enable = true;
      # TODO: fix this
      bashrcExtra = ''
        . /etc/nixos/configs/.bashrc
      '';
    };

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    # home.file.".bashrc".source = ../../configs/.bashrc;
    home.file.".vimrc".source  = ../configs/.vimrc;

    programs.git = {
      enable = true;
      extraConfig = {
        url = {
          "git@github.com:" = {
            insteadOf = "https://github.com/";
          };
        };
      };
      ignores = [
        ".direnv/*"
      ];
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
        # yoavbls.pretty-ts-errors
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
        "<C-v>" = false;
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

    programs.rofi = {
      enable = true;
      theme = ../configs/rofi/theme.rasi;
    };
    services.polybar = {
      enable = true;
      script = "polybar bar &";
    };

    home.file.".config/qtile/config.py".source              = ../configs/qtile.py;
    home.file.".xbindkeysrc".source                         = ../configs/.xbindkeysrc;
    home.file.".config/autostart/.flameshot.desktop".source = ../configs/desktop-entries/flameshot.desktop;
    home.file.".config/autostart/.xbindkeys.desktop".source = ../configs/desktop-entries/xbindkeys.desktop;
    home.file.".config/autostart/.polybar.desktop".source   = ../configs/desktop-entries/polybar.desktop;
    home.file.".config/mimeapps.list".source                = ../configs/mimeapps.list;
    home.file.".ideavimrc".source                           = ../configs/.ideavimrc;
    home.file.".local/share/Steam/steamapps/common/Counter-Strike Global Offensive/game/csgo/cfg/autoexec.cfg".source                        = ../configs/csgo/autoexec.cfg;
  };
}