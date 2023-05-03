
{ pkgs, config, services, ... }:
let 
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  home-manager.users.${config.lib.user.name} = { pkgs, ... }: {
    home.stateVersion = "22.11"; # DO NOT CHANGE
    nixpkgs.config.allowUnfree = true;

    imports = [
      ./home/default.nix
    ];

    # home.packages = [ 
    #   pkgs.neofetch 
    #   unstable.jetbrains.datagrip # by default has 2022.2 which is too old
    #   pkgs.microsoft-edge
    #   pkgs.slack
    #   pkgs.insomnia
    #   pkgs.zoom-us
    #   pkgs.libsForQt5.okular
    #   pkgs.obs-studio
    #   pkgs.firefox
    #   pkgs.xbindkeys
    #   pkgs.vlc
    #   pkgs.alacritty
    # ];

    home.file.".bashrc".source = ../configs/.bashrc;
    home.file.".vimrc".source = ../configs/.vimrc;
    home.file.".config/qtile/config.py".source = ../configs/qtile.py;
    home.file.".xbindkeysrc".source = ../configs/.xbindkeysrc;
    home.file.".config/autostart/.flameshot.desktop".source = ../configs/desktop-entries/flameshot.desktop;
    home.file.".config/autostart/.xbindkeys.desktop".source = ../configs/desktop-entries/xbindkeys.desktop;
    home.file.".config/autostart/.polybar.desktop".source = ../configs/desktop-entries/polybar.desktop;
    home.file.".config/mimeapps.list".source = ../configs/mimeapps.list;

    programs.rofi = {
      enable = true;
      theme = ../configs/rofi/theme.rasi;
    };
    services.polybar = {
      enable = true;
      script = "polybar bar &";
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
  };
}