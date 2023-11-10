{ stable, unstable, config, services, name, ... }:
{
  home-manager.users.${name} = { ... }: {
    home.packages = [ 
      unstable.jetbrains.datagrip
      unstable.microsoft-edge
      stable.slack
      stable.insomnia
      stable.zoom-us
      stable.obs-studio
      stable.firefox
      stable.alacritty
      stable.azure-cli
      stable.peek
      stable.shotcut
    ];

    programs.alacritty = {
      enable = true;
      settings.window = {
        opacity = 0.95;
        dimensions = {
          lines = 40;
          columns = 150;
        };
      };
    };

    programs.vscode = {
      enable = true;
      mutableExtensionsDir = false; # home-manager stopped installing extensions at some point and this fixed it
      extensions = with stable.vscode-extensions; [
        vscodevim.vim
        bbenoist.nix
        jnoortheen.nix-ide
        formulahendry.auto-rename-tag
        formulahendry.auto-close-tag
        dbaeumer.vscode-eslint
        eamodio.gitlens
        esbenp.prettier-vscode 
        # kamadorueda.alejandra
        # dlasagno.rasi
        tomoki1207.pdf
        # yoavbls.pretty-ts-errors
      ];
      userSettings = {
        # "vim.useSystemClipboard" = true;
        "workbench.editor.wrapTabs" = true; # have tabs become multiline instead of scroll
        "emmet.showExpandedAbbreviation" = "never"; # emmet gets in the way

        # don't open modal on goto, just go to
        "editor.gotoLocation.multipleTypeDefinitions" = "goto";
        "editor.gotoLocation.multipleImplementations" = "goto";
        "editor.gotoLocation.multipleDefinitions" = "goto";
        "editor.gotoLocation.multipleDeclarations" = "goto";
        "editor.wordWrap" = "on";
        "editor.cursorBlinking" = "smooth";
        "editor.unicodeHighlight.invisibleCharacters" =  true;
        "editor.menuBarVisibility" = "hidden";
        "editor.formatOnPaste" = true;
        "breadcrumbs.enabled" = false;
        "customizeUI.activityBar" = "top";

        "vim.normalModeKeyBindings" = [
          {
            "before" = ["g" "r"];
            "commands" = ["editor.action.goToReferences"];
          }
        ];
        "vim.showMarksInGutter" = true;

        "vim.handleKeys" = {
          "<C-f>" = false;
          "<C-x>" = false;
          "<C-v>" = false;
          "<C-c>" = false;
          "<C-p>" = false;
        };

        "[typescriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[javascript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
      };
    };
  };
}