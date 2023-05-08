	{pkgs, config, ...}: 
  
  {
    system.stateVersion = 4;
    # here are the darwin preferences and configs
    programs.zsh.enable = true;
    environment.shells = [ pkgs.bash pkgs.zsh ];
    environment.loginShell = pkgs.zsh;
    environment.systemPackages = with pkgs; [ 
      # coreutils 
      git 
      # nodejs
      # nodePackages.npm
      # nodePackages.yarn
      # watchman
      # ruby
      # rubyPackages.ffi
      # cocoapods
      # xcbuild
      # xcodebuild6
    ]; 
    environment.systemPath = [ "/opt/homebrew/bin" ];
    environment.pathsToLink = [ "/Applications" ];
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';
    system.keyboard.enableKeyMapping = true;
    services.nix-daemon.enable = true;
    system.defaults = {
      finder.AppleShowAllExtensions = true; # shows file extensions in file name
      finder._FXShowPosixPathInTitle = true;
      finder.ShowPathbar = true;
      finder.ShowStatusBar = true;
      finder.FXPreferredViewStyle = "Nlsv"; #list view
      finder.AppleShowAllFiles = true; #shows hidden files
      dock.tilesize = 36;
      dock.static-only = true; #shows only open apps
      dock.mru-spaces = false; # don't automatically rearrange spaces based on most recent use. who thought this was a good idea? 
      dock.autohide-time-modifier = 0.5; # default is 1.0
      dock.autohide = true;
      # NSGlobalDomain.com.apple.trackpad.scaling = 1.2; # trackpad tracking speed, default is 1 
      # NSGlobalDomain.com.apple.keyboard.fnState = false; # f1-f12 keys as function keys
      NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false; # don't save documents to iCloud by default
      NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false; # no automatic spelling correction
      NSGlobalDomain.AppleShowScrollBars = "Always";
      NSGlobalDomain.AppleShowAllFiles = true;
      NSGlobalDomain.AppleShowAllExtensions = true;
      NSGlobalDomain.AppleInterfaceStyle = "Dark";
      NSGlobalDomain.InitialKeyRepeat = 14;
      NSGlobalDomain.KeyRepeat = 1;
      # GlobalPreferences.com.apple.sound.beep.sound = # look in /System/Library/Sounds for possible candidates, takes in a path


    };
    
    homebrew = {
      enable = true;
      caskArgs.no_quarantine = true;
      global.brewfile = true;
      masApps = {
        Xcode = 497799835;
      };
      casks = [
        "raycast" 
        "amethyst"
        "microsoft-edge" # not on nixpm yet
        "firefox"
      ];
    };

    # my changes:
    # system.defaults.screencapture.location = ~/Desktop;
}