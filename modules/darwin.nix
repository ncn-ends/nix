	{pkgs, ...}: 
  
  {
    system.stateVersion = 4;
    # here are the darwin preferences and configs
    programs.zsh.enable = true;
    environment.shells = [ pkgs.bash pkgs.zsh ];
    environment.loginShell = pkgs.zsh;
    environment.systemPackages = [ pkgs.coreutils pkgs.git ]; 
    environment.systemPath = [ "/opt/homebrew/bin" ];
    environment.pathsToLink = [ "/Applications" ];
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';
    system.keyboard.enableKeyMapping = true;
    services.nix-daemon.enable = true;
    system.defaults = {
      NSGlobalDomain.AppleShowAllExtensions = true;
      NSGlobalDomain.InitialKeyRepeat = 14;
      NSGlobalDomain.KeyRepeat = 1;
      finder.AppleShowAllExtensions = true; # shows file extensions in file name
      finder._FXShowPosixPathInTitle = true;
      finder.ShowPathbar = true;
      finder.ShowStatusBar = true;
      finder.FXPreferredViewStyle = "Nlsv"; #list view
      finder.AppleShowAllFiles = true; #shows hidden files
      dock.tilesize = 24;
      dock.static-only = true; #shows only open apps
      dock.mru-spaces = false; # don't automatically rearrange spaces based on most recent use. who thought this was a good idea? 
      dock.autohide-time-modifier = 2.0; # default is 1.0
      dock.autohide = true;
    };
    
    homebrew = {
      enable = true;
      caskArgs.no_quarantine = true;
      global.brewfile = true;
      masApps = {};
      casks = ["raycast" "amethyst"];
    };

    # my changes:
    # system.defaults.screencapture.location = ~/Desktop;
}