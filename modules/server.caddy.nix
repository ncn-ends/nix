{ stable, config, ...}: {
  environment.systemPackages = [stable.caddy];
  services.caddy = {
    enable = true;

    virtualHosts."nixos.tail7d98c.ts.net".extraConfig = ''
      reverse_proxy localhost:8222
    '';
  };
}
# https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/services/security/vaultwarden/default.nix
    # virtualHosts."nixos.tail7d98c.ts.net/vw".extraConfig = ''
    # '';
    # virtualHosts."http://hub.ncn.dev".extraConfig = ''
    #   respond "Hello, world!"
    # '';