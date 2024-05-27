{ machine, config, lib, modulesPath, imports, ... }:
let 
  stable = imports.stable;
in {
  system.stateVersion = "21.11";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  
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

  # set maximum file watchers - required for node and jetbrains IDEs if you have too many things open
  # https://intellij-support.jetbrains.com/hc/en-us/articles/15268113529362-Inotify-Watches-Limit-Linux
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 1048576;
  };

  fonts.packages = [
    stable.roboto-mono
  ];

  users.users.${machine.user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner" "docker" "plex" ];
    initialPassword = "password";
  };

  home-manager.users.${machine.user} = { ... }: {
    home.stateVersion = "22.11";
    nixpkgs.config.allowUnfree = true;

    programs.bash = {
      enable = true;
      bashrcExtra = ''
        . /etc/nixos/configs/shell/.bashrc
      '';
    };
  };

  virtualisation.docker.enable = true;

  # --- mostly came from hardware-configuration.nix ---

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = { 
    device = "/dev/disk/by-uuid/8f2b4ac7-ab2d-458d-b61a-2aa1545dfa5e";
    fsType = "ext4";
  };

  fileSystems."/boot" = { 
    device = "/dev/disk/by-uuid/6D00-DB7E";
    fsType = "vfat";
  };

  fileSystems."/mnt/shape" = {
    fsType = "ext4";
    label = "shape";
    device = "/dev/disk/by-label/shape";
    depends = [ "/" "/boot" ];
    options = [ "defaults" "nofail" ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # thunar stuff

  programs.thunar = {
    enable = true;
    plugins = [
      stable.xfce.thunar-archive-plugin
    ];
  };
  # required to save preferences if not using xfce
  programs.xfconf.enable = true;
  # image thumbnails
  # https://wiki.archlinux.org/title/File_manager_functionality#Thumbnail_previews
  services.tumbler.enable = true;

  environment.variables = {
    # required to make yarn install work https://github.com/NixOS/nixpkgs/issues/314713
    UV_USE_IO_URING = "0";
  };
}