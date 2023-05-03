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
      finder.AppleShowAllExtensions = true;
      finder._FXShowPosixPathInTitle = true;
      dock.autohide = true;
    };
    
    homebrew = {
      enable = true;
      caskArgs.no_quarantine = true;
      global.brewfile = true;
      masApps = {};
      casks = ["raycast" "amethyst"];
    };
}