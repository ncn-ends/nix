
{ services, stable, unstable, config, ... }:
let 
  # inherit (import ../helpers/fetch-packages.nix {}) stable unstable;
  name = "one";
in {
  home-manager.users.${name} = { ... }: {
    home.stateVersion = "22.11"; # DO NOT CHANGE
    nixpkgs.config.allowUnfree = true;

    home.packages = [ 
      # default
      unstable.jetbrains.datagrip
      unstable.microsoft-edge
      stable.slack
      stable.insomnia
      stable.zoom-us
      stable.obs-studio
      stable.firefox
      # unstable.vlc
      stable.alacritty
      stable.azure-cli
      # stable.figma-linux # marked as insecure
    
      # home only
      stable.neofetch 
      stable.libsForQt5.okular
      stable.xbindkeys
      stable.libreoffice
      stable.peek
      stable.psensor
      stable.imagemagick
      stable.tokei
      stable.speedtest-cli
      stable.shotcut
      stable.krusader
      stable.libsForQt5.dolphin
      stable.bottom
      stable.gimp
      stable.libsForQt5.kdeconnect-kde
      stable.screenkey

      # music player
      stable.youtube-music
    ];

    programs.vim = {
      enable = true;
      # defaultEditor = true; # stopped working after switching home manager import
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
      extensions = with stable.vscode-extensions; [
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
      config = ../configs/polybar/config.ini;
      package = stable.polybar;
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