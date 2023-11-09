{ stable, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true; 
  boot.kernelPackages = stable.linuxPackages_latest; 
  boot.initrd.kernelModules = ["amdgpu"]; 
  boot.loader.grub.device = "/dev/sda";
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     useXkbConfig = true;
  };
  hardware.pulseaudio.enable = true;

  systemd.extraConfig = ''
    DefaultLimitNOFILE=1048576
  '';

  systemd.user.extraConfig = ''
    DefaultLimitNOFILE=1048576
  '';

  fonts.packages = with stable; [
    montserrat
    roboto
    roboto-mono
  ];
}