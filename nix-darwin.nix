{}:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 4;
  nix.settings.experimental-features = "nix-command flakes";
  system.configurationRevision = self.rev or self.dirtyRev or null;
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  environment.systemPackages = [
    pkgs.vim
  ];
  programs.zsh.enable = true;  
}


# might be needed, same place as nixosConfigurations and darwinConfigurations are defined
    # # Expose the package set, including overlays, for convenience.
    # darwinPackages = self.darwinConfigurations."ncns-MacBook-Pro".pkgs;