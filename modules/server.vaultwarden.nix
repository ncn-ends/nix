{ stable, config, ...}:
let
  vwDir = "/run/media/one/shape/vaultwarden";
in {
  # services.vaultwarden = {
  #   enable = true;
  #   # backupDir = "${vwDir}/backup";
  #   config = {
  #     DATA_FOLDER = vwDir;
  #   };
  # };

  # systemd.tmpfiles.rules = [
  #   "d ${vwDir} 0755 vaultwarden vaultwarden - -"
  #   # "d ${vwDir}/backup 0755 vaultwarden vaultwarden - -"
  # ];

  services.vaultwarden.enable = true;
}