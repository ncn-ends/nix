{ imports, sops-nix, ...}:
{
  imports = [
    sops-nix.nixosModules.sops
  ];

  environment.systemPackages = [ imports.stable.sops ];

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  # where to look for private keys
  sops.age.keyFile = "/home/one/.config/sops/age/keys.txt";

  # reveals secrets in file system at /run/secrets/
  sops.secrets.tailscale-minecraft = {};
}