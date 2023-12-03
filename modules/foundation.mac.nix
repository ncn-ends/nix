{ stable, unstable, self, name, ... }:
{
  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.settings.experimental-features = "nix-command flakes";
  system.configurationRevision = self.rev or self.dirtyRev or null;
  users.users."ncn".home = "/Users/ncn";
  users.users."ncn".name = "ncn";
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nixpkgs.config.allowUnfree = true;

  # not too sure what these are for or if they're necessary
  environment.shells = [ stable.bash stable.zsh ];
  environment.loginShell = stable.zsh;

  # may be needed when adding homebrew to nix config
  # environment.systemPath = [ "/opt/homebrew/bin" ];
  
  # not sure what this is for
  # environment.pathsToLink = [ "/Applications" ];

  # example homebrew config
    #   homebrew = {
    #   enable = true;
    #   caskArgs.no_quarantine = true;
    #   global.brewfile = true;
    #   masApps = {
    #     Xcode = 497799835;
    #   };
    #   casks = [];
    # };

  # i think this is if you want to customize key remapping within nix
  # system.keyboard.enableKeyMapping = true; 
  system.defaults = {
    # dark mode
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    # always show file extensions in finder and in general
    finder.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
    # show full path at the top of the finder window
    finder._FXShowPosixPathInTitle = true;
    # show breadcrumbs in finder
    finder.ShowPathbar = true;
    # status bar with stats at bottom of finder
    finder.ShowStatusBar = true;
    # default to list view in finder
    finder.FXPreferredViewStyle = "Nlsv";
    # show hidden files in finder and in general
    finder.AppleShowAllFiles = true; 
    NSGlobalDomain.AppleShowAllFiles = true;
    # size of icons in dock
    dock.tilesize = 36;
    # only shows open apps in the dock
    dock.static-only = true; 
    # don't automatically rearrange spaces based on most recent use. who thought this was a good idea? 
    dock.mru-spaces = false; 
    # time to hide dock, default is 1.0 
    dock.autohide-time-modifier = 0.5;
    dock.autohide = true;
    # don't save documents to iCloud by default
    NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
    # no automatic spelling correction
    NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
    # always show all scrollbars
    NSGlobalDomain.AppleShowScrollBars = "Always";
    # how long to wait before repeating character when held down
    NSGlobalDomain.InitialKeyRepeat = 14;
    # speed of character repeat when held down
    NSGlobalDomain.KeyRepeat = 1;
    NSGlobalDomain."com.apple.keyboard.fnState" = true;
    # NSGlobalDomain.com.apple.trackpad.scaling = 1.2; # trackpad tracking speed, default is 1 
  };


  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${name} = { ... }: {
    home.username = name;
    programs.home-manager.enable = true;
    nixpkgs.config.allowUnfree = true;
    home.packages = [
      # stable.obs-studio
      unstable.jetbrains.webstorm
    ];  
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
      export PATH=$PATH:/run/current-system/sw/bin
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