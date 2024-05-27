{ config, drives, ...}:
let 
  dataDir = "${drives.shape.location}/syncthing";
in {
  # https://wes.today/nixos-syncthing/
  services.syncthing = {
    enable = true;
    dataDir = dataDir;
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
        "razr" = { id = "FK4I66O-OY3OCGP-463GPGA-FAGYDOD-GE3FMOF-HFWBI3U-N5DCZDO-KS5W5QC"; };
        "one" = { id = "placeholder"; };
      };
      folders = {
        # "dump" = {
        #   path = "/run/media/one/shape1/syncthing/dump";
        #   devices = [ "s10" ];
        # };
        "razr_sync" = {
          id = "razr_sync";
          label = "razr_sync";
          path = "${dataDir}/razr";
          devices = [ "razr" ];
        };
      };
    };
  };
}

# for any new device, add it to devices with the device id found somewhere in the client app's gui
# for a new folder to sync:
#   - config: 
#     - the name can be anything
#     - the path should be the path to store the files. extend from {dataDir}
#     - add the devices that should sync with it
#   - client side changes:
#     - add the folder with the correct id