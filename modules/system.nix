{ stable, unstable, config, services, name, ... }:
{
  environment.systemPackages = [
    stable.wget
  ];

  users.users.${name}.packages = [
    unstable.ranger
  ];

  virtualisation.docker.enable = true; # TODO: move this

  # TODO: can remove these if get vlc working without flatpak
  xdg.portal.enable = true; # required for flatpak
  services.flatpak.enable = true;
  # flatpak packages: flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  #   - vlc

  home-manager.users.${name} = { ... }: {
    programs.vim = {
      enable = true;
      # TODO: make vim default editor
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

    home.file.".ideavimrc".source  = ../configs/.ideavimrc;
    home.file.".vimrc".source      = ../configs/.vimrc;
  };
}