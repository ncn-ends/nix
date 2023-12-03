{ stable, self, name, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 4;
  nix.settings.experimental-features = "nix-command flakes";
  system.configurationRevision = self.rev or self.dirtyRev or null;
  users.users."ncn".home = "/Users/ncn";
  users.users."ncn".name = "ncn";
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nixpkgs.config.allowUnfree = true;

  system.defaults = {
    # always show file extensions in finder
    finder.AppleShowAllExtensions = true;
    # show full path at the top of the finder window
    finder._FXShowPosixPathInTitle = true;
  };


  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${name} = { ... }: {
    home.username = name;
    programs.home-manager.enable = true;
    nixpkgs.config.allowUnfree = true;
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      # enableAutoSuggestions = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        nix-sw = "darwin-rebuild switch --flake ~/nix2/flake.nix";
        # nixup = "pushd ~/nix/darwin; nix flake update; nixsw; popd";
        # nixrn = "NIXPKGS_ALLOW_UNFREE=1 nix-shell ~/nix/shells/rn-shell.nix";
      };
      initExtra = ''
      export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
      export ANDROID_HOME=$ANDROID_SDK_ROOT
      export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
      export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
      export NODE_BINARY=/Users/ncn/.nvm/versions/node/v16.20.0/bin/node
      '';
    };	
    # TODO: this is repeated from gui.common.nix, consolidate
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
  };
}