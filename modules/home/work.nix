
{ pkgs, services, config, ... }:

{
  home.stateVersion = "22.11"; # DO NOT CHANGE
  nixpkgs.config.allowUnfree = true;

  # missing packages are added in darwin file
  home.packages = with pkgs; [
    slack
    # pkgs.microsoft-edge
    slack
    # pkgs.insomnia
    zoom-us
    # pkgs.obs-studio
    # pkgs.firefox
    # pkgs.vlc
    # pkgs.alacritty
    azure-cli
    # pkgs.android-studio
    nodejs
    nodePackages.npm
    nodePackages.yarn
    cocoapods
  ];
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
  # imports = [
  #   ./default.nix
  # ];
  home.sessionVariables = {};
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # enableAutoSuggestions = true;
    enableSyntaxHighlighting = true;
    shellAliases = {
      nixsw = "darwin-rebuild switch --flake ~/nix/darwin/.#";
      nixup = "pushd ~/nix/darwin; nix flake update; nixsw; popd";
      nixrn = "NIXPKGS_ALLOW_UNFREE=1 nix-shell ~/nix/shells/rn-shell.nix";
    };
  };	
  programs.alacritty = {
    enable = true;
  };
  
}