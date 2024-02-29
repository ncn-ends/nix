
{ stable, unstable, config, services, name, ... }:
{
  home-manager.users.${name} = { ... }: {
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
        # "workbench.editor.showTabs" = false;
        "workbench.tree.indent" = 20;
        "emmet.showExpandedAbbreviation" = "never"; # emmet gets in the way

        # don't open modal on goto, just go t0
        "editor.gotoLocation.multipleTypeDefinitions" = "goto";
        "editor.gotoLocation.multipleImplementations" = "goto";
        "editor.gotoLocation.multipleDefinitions" = "goto";
        "editor.gotoLocation.multipleDeclarations" = "goto";
        "editor.wordWrap" = "on";
        "editor.wrappingColumn" = 0;
        "editor.cursorBlinking" = "smooth";
        "editor.unicodeHighlight.invisibleCharacters" =  true;
        "editor.menuBarVisibility" = "hidden";
        "editor.formatOnPaste" = true;
        "breadcrumbs.enabled" = false;
        "customizeUI.activityBar" = "top";
        "files.autoSave"= "afterDelay"; 
        "files.autoSaveDelay"= 1000;

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
          "<C-w>" = false;
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
