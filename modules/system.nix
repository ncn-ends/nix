{ stable, unstable, config, services, name, ... }:
{
  environment.systemPackages = [
    stable.wget
    stable.unzip
  ];

  users.users.${name}.packages = [
    unstable.ranger
  ];

  home-manager.users.${name} = { ... }: {
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