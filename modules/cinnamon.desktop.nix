{ pkgs, services, ... }:
{
  services.xserver = {
    enable = true;
    libinput.enable = true;
    displayManager.lightdm.enable = true;
    displayManager.defaultSession = "cinnamon";
    desktopManager.cinnamon.enable = true;
    videoDrivers = [ "amdgpu" ];
  };
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      amdvlk
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}