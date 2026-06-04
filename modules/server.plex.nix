{ ... }:
{
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  # Temporary: pin to 10.10.7 to run intermediate db migration before upgrading to 10.11
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    # package = imports.oldstable.jellyfin;
  };
}
