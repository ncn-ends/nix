{ imports, sops-nix, ...}:
{
  imports = [
    sops-nix.nixosModules.sops
  ];

  environment.systemPackages = [ imports.stable.sops ];

  # where secrets are stored. when you want to edit it, do `sops ../secrets/secrets.yaml`
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  # where to look for private keys
  sops.age.keyFile = "/home/one/.config/sops/age/keys.txt";

  # this will place a file at /run/secrets
  # each key of this set matches to a file in this directory, with the value being whatever is in your secrets
  # you can assign owners to each key by adding `owner` prop
  # you will have to use the cat command to get the contents of the key
  sops.secrets = {
    tailscale = {};
  };
}
