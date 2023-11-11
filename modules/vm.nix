{ config, stable, name, ...}:
{
  # ---
  # IMPORTANT NOTE
  # initially when loading virt manager, you need to do file -> add connection. leave at defaults, then hit ok. you'll then see QEMU/KVM
  # ---



  # key based configuration storage system, back end to GSettings
  programs.dconf.enable = true;

  users.users.${name}.extraGroups = ["libvirtd"];

  environment.systemPackages = with stable; [
    # GUI front end for VM management
    virt-manager

    # more options to view VMs
    virt-viewer

    # graphics virtualization
    spice spice-gtk spice-protocol

    # drivers for windows VMs
    win-virtio win-spice

    # for non-gnome DEs, may see errors if you don't have this
    gnome.adwaita-icon-theme
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ stable.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
}