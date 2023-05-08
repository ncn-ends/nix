{ pkgs, config, services, ... }:
let 
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  home.stateVersion = "22.11"; # DO NOT CHANGE
  nixpkgs.config.allowUnfree = true;

  home.packages = [ 
    unstable.jetbrains.datagrip # by default has 2022.2 which is too old
    pkgs.microsoft-edge
    pkgs.slack
    pkgs.insomnia
    pkgs.zoom-us
    pkgs.obs-studio
    pkgs.firefox
    unstable.vlc
    pkgs.alacritty
    pkgs.azure-cli
  ];

  home.file.".bashrc".source = ../../configs/.bashrc;
  home.file.".vimrc".source  = ../../configs/.vimrc;

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
}