{ imports, config, services, machine, ... }:
let
  stable = imports.stable;
in
{
  environment.systemPackages = [
    # these 3 are for nix support in vs code
    stable.nil
    stable.nixpkgs-fmt
    stable.statix
  ];

  home-manager.users.${machine.user} = { ... }: {
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

        ms-python.python
        # yoavbls.pretty-ts-errors

        timonwong.shellcheck
      ];
      userSettings = {
        # "vim.useSystemClipboard" = true;
        "workbench.editor.wrapTabs" = true; # have tabs become multiline instead of scroll
        # "workbench.editor.showTabs" = false;
        "workbench.tree.indent" = 20;
        "emmet.showExpandedAbbreviation" = "never"; # emmet gets in the way

        # visual guide for line length
        "editor.rulers" = [ 80 120 ];

        # see bracket pairs easier
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = true;

        # when opening vs code won't open last closed window, opens blank window
        "window.restoreWindows" = "none";

        # don't open a new tab with release notes when it updates
        "update.showReleaseNotes" = false;

        # don't open modal on goto, just go to
        "editor.gotoLocation.multipleTypeDefinitions" = "goto";
        "editor.gotoLocation.multipleImplementations" = "goto";
        "editor.gotoLocation.multipleDefinitions" = "goto";
        "editor.gotoLocation.multipleDeclarations" = "goto";
        "editor.wordWrap" = "on";
        "editor.wrappingColumn" = 0;
        "editor.cursorBlinking" = "smooth";
        "editor.unicodeHighlight.invisibleCharacters" = true;
        "editor.menuBarVisibility" = "hidden";
        "editor.formatOnPaste" = true;
        "breadcrumbs.enabled" = false;
        "customizeUI.activityBar" = "top";
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        # improves folder structure visibility
        "explorer.compactFolders" = true;

        # vim
        "vim.normalModeKeyBindings" = [
          {
            "before" = [ "g" "r" ];
            "commands" = [ "editor.action.goToReferences" ];
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
        "vim.hlsearch" = true; # highlight search matches

        # js / ts
        "[typescriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[javascript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "javascript.updateImportsOnFileMove.enabled" = "always";
        "typescript.updateImportsOnFileMove.enabled" = "always";

        # nix
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.serverSettings" = {
          "nil" = {
            "formatting" = {
              "command" = "nixpkgs-fmt";
            };
          };
        };
      };
    };
  };
}
