{ services, ... }:
{
  users.users.one = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner" "docker" ];
    initialPassword = "password";
  };
}