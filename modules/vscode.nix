{ imports, config, services, machine, ... }:
let
  stable = imports.stable;
  unstable = imports.unstable;
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
      package = unstable.vscode;
      profiles.default.extensions = with stable.vscode-extensions; [
        vscodevim.vim
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
        yoavbls.pretty-ts-errors

        timonwong.shellcheck

        # adds support for dotenv files
        mikestead.dotenv

        # auto completes npm packages in import modules
        christian-kohler.npm-intellisense

        # mxsdev.typescript-explorer

        # (stable.vscode-utils.extensionFromVscodeMarketplace {
        #   publisher = "ms-mssql";
        #   name = "mssql";
        #   version = "latest";
        #   sha256 = "sha256-WnC0W5SShQuGsQBmC8eEy++NhpKaoCx6lzKjJ+koz08=";
        # })

        # Inline error/warning display — pairs well with your ESLint setup
        usernamehw.errorlens

        # Much better Python language server (type checking, IntelliSense)
        ms-python.vscode-pylance

        # nice for tailwind
        bradlc.vscode-tailwindcss
      ];
      profiles.default.keybindings = [
        {
          key = "alt+left";
          command = "workbench.action.navigateBack";
        }
        {
          key = "alt+right";
          command = "workbench.action.navigateForward";
        }
      ];
      profiles.default.userSettings = {
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
        "editor.wordWrapColumn" = 0;
        "editor.cursorBlinking" = "smooth";
        "editor.unicodeHighlight.invisibleCharacters" = true;
        "editor.menuBarVisibility" = "hidden";
        "editor.formatOnPaste" = true;
        "breadcrumbs.enabled" = false;
        "editor.formatOnSave" = true;
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        # auto-renames matching HTML/JSX tags as you type
        "editor.linkedEditing" = true;
        # improves folder structure visibility
        "explorer.compactFolders" = true;

        # terminal improvements
        "terminal.integrated.gpuAcceleration" = "on";
        "terminal.integrated.persistentSessionReviveProcess" = "never";
        "terminal.integrated.cursorBlinking" = true;
        "terminal.integrated.cursorStyle" = "line";

        # disable minimap
        "editor.minimap.enabled" = false;

        # highlight modified editor tabs
        "workbench.editor.highlightModifiedTabs" = true;

        # keeps the current function/class signature pinned at the top as you scroll
        "editor.stickyScroll.enabled" = true;
        "editor.stickyScroll.maxLineCount" = 3;
        
        # make hover appear faster
        "editor.hover.delay" = 300;

        # Hides whitespace changes
        "diffEditor.ignoreTrimWhitespace" = true;
        # hide cursor position indicator in scrollbar
        "editor.hideCursorInOverviewRuler" = true;
        # only shows errors and git changes in scrollbar. TODO: may want to include find results too, but hard to fine control it.
        "editor.overviewRulerLanes" = 0;
        # sets color for modified lines to blue
        "editor.gutter.modifiedBackground" = "#0070aa";
        # sets line adds to green in scroll bar 
        "editor.gutter.addedBackground" = "#2ea043";
        # sets errors to red in scroll bar
        "editorError.foreground" = "#ff0000";

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
