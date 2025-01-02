{ config, services, imports, machine, ... }:
let 
  stable = imports.stable; 
  unstable = imports.unstable;
in {
  environment.systemPackages = [
    stable.wget
    stable.unzip
    stable.python3
  ];

  users.users.${machine.user}.packages = [
    # unstable.ranger
  ];

  home-manager.users.${machine.user} = { ... }: {
    programs.alacritty = {
      enable = true;
      settings.window = {
        opacity = 0.95;
        dimensions = {
          lines = 40;
          columns = 120;
        };
      };
    };

    programs.vim = {
      enable = true;
      defaultEditor = true;
    };
      
    home.sessionVariables = {
      # default editor set to vim
      EDITOR = "vim";
      SUDO_EDITOR = "vim";
      GIT_EDITOR = "vim";
      GIT_SEQUENCE_EDITOR = "vim";
    };

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    programs.git = {
      enable = true;
      extraConfig = {
        url = {
          "git@github.com:" = {
            insteadOf = "https://github.com/";
          };
        };
        core = {
          editor = "vim";
        };
      };
      ignores = [
        ".direnv/*"
      ];
    };

    home.file.".ideavimrc".source  = ../configs/vim/.ideavimrc;
    home.file.".vimrc".source      = ../configs/vim/.vimrc;
    home.file.".config/ranger" = {
      recursive = true;
      source = ../configs/ranger;
    };
  };
}