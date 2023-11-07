{ services, ... }:
let 
  inherit (import ../helpers/fetch-packages.nix {}) stable;
in {
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
    extraPackages = with stable; [
      amdvlk
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}