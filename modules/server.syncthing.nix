{ stable, config, ...}:
{
  # https://wes.today/nixos-syncthing/
  # TODO: use machine.shape.location to make the data directories consistent
  services.syncthing = {
    enable = true;
    dataDir = "/run/media/one/shape1/syncthing";
    openDefaultPorts = true;
    configDir = "/home/one/.config/syncthing";
    user = "one";
    group = "users";
    guiAddress = "127.0.0.1:8384";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "s10" = { id = "RT5ULAR-676SHP6-WZ5UWS3-4VI3WBU-RNH5LJ7-PK3BOCZ-U6CAICR-L3SROAN"; };
        "razr" = { id = "placeholder"; };
        "one" = { id = "placeholder"; };
      };
      folders = {
        "dump" = {
          path = "/run/media/one/shape1/syncthing/dump";
          devices = [ "s10" ];
        };
      };
    };
  };
}