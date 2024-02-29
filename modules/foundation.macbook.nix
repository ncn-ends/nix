{ stable, unstable, self, name, machine, ... }:
{
  system.stateVersion = 4;
  nixpkgs.hostPlatform = machine.system;
  nix.settings.experimental-features = "nix-command flakes";
  home-manager.users.${name} = { ... }: {
    home.stateVersion = "22.11";
    nixpkgs.config.allowUnfree = true;
  };
  system.configurationRevision = self.rev or self.dirtyRev or null;
  users.users.${machine.user} = {
    name = machine.user;
    home = "/Users/${machine.user}";
  };
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nixpkgs.config.allowUnfree = true;

  # not too sure what these are for or if they're necessary
  environment.shells = [ stable.zsh ];
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
    # require fn keys to hold fn to do their duty
    NSGlobalDomain."com.apple.keyboard.fnState" = true;
    # NSGlobalDomain.com.apple.trackpad.scaling = 1.2; # trackpad tracking speed, default is 1 
    # 24 hour time
    NSGlobalDomain.AppleICUForce24HourTime = true;
    # add feedback sound when volume is changed
    NSGlobalDomain."com.apple.sound.beep.feedback" = 1;
    # only shows open apps in the dock
    dock.static-only = true; 
    # don't automatically rearrange spaces based on most recent use.
    dock.mru-spaces = false; 
    # autohide dock, animation speed. can also have autohide-delay
    dock.autohide = true;
    dock.autohide-time-modifier = 0.5;
    # size of icons in dock
    dock.tilesize = 36;
    # make icon bigger on hover and icon size on hover
    dock.magnification = true; 
    dock.largesize = 64; # default
    # hide icons on desktop
    finder.CreateDesktop = false;
    # allow quitting finder
    finder.QuitMenuItem = true;
    # no guest user allowed on log in
    loginwindow.GuestEnabled = false;
    # can normally type >console on user name to get console access at log in window. this prevents that
    loginwindow.DisableConsoleAccess = true;
    # minimize animation
    dock.minimize-to-application = true;

    # --- experimenting ---
    # these did not work
    screencapture.location = "/Users/${machine.user}/captures";
    screencapture.type = "jpg";
    # not sure
    dock.enable-spring-load-actions-on-all-items = true;
    # set size of cursor
    # universalaccess.mouseDriverCursorSize = 3.99;
    # font smoothing
    NSGlobalDomain.AppleFontSmoothing = 2;
  };

  environment.systemPackages = [
      # stable.zulu17 # jdk for react native
      # stable.jdk17
      stable.nodejs
      stable.nodePackages.npm
      stable.nodePackages.yarn
  ];

  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';


  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${machine.user} = { ... }: {
    home.username = machine.user;
    programs.home-manager.enable = true;
    nixpkgs.config.allowUnfree = true;
    home.packages = [
      # stable.obs-studio
      unstable.jetbrains.webstorm
      # unstable.jetbrains.rider
      stable.azure-cli
      stable.insomnia
    ];  
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      # enableAutoSuggestions = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        nix-sw = "darwin-rebuild switch --flake ${machine.nixConfigRoot}/flake.nix";
        # nixup = "pushd ~/nix/darwin; nix flake update; nixsw; popd";
        # nixrn = "NIXPKGS_ALLOW_UNFREE=1 nix-shell ~/nix/shells/rn-shell.nix";
      };
      initExtra = ''
      export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
      export ANDROID_HOME=$ANDROID_SDK_ROOT
      export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
      export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
      export PATH=$PATH:/run/current-system/sw/bin
      '';
    };	
      # export JAVA_HOME=${stable.zulu17}/lib/openjdk
      # export PATH=$JAVA_HOME:$PATH
  };
}