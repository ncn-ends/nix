{
  machine,
  config,
  lib,
  modulesPath,
  imports,
  ...
}:
let
  stable = imports.stable;
in
{
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
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.loader.grub.device = "/dev/sda";

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  environment.systemPackages = [
    stable.openssl
    stable.libsecret
    # stable.openssl_3_3
    # stable.soulseekqt # removed due to lack of maintenance in nixpkgs

    # for razer m
    # stable.openrazer-daemon
    # stable.polychromatic

    stable.nvtopPackages.amd # htop for GPUs
    stable.rocmPackages.rocm-smi # gives list of PIDs + VRAM
  ];

  # sound
  hardware.pulseaudio.enable = false; # turned off due to conflicts with hardware.opengl.driSupport
  security.rtkit.enable = true; # recommended for pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # hardware.alsa.enablePersistence = true;

  systemd.settings.Manager = {
    DefaultLimitNOFILE = 1048576;
  };

  # switch-to-configuration restarts nsncd multiple times when store paths change,
  # hitting the default StartLimitBurst=5 within one second
  systemd.services.nscd.serviceConfig.StartLimitIntervalSec = lib.mkForce 0;

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
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "networkmanager"
      "lp"
      "scanner"
      "docker"
      "plex"
      "openrazer"
    ];
    initialPassword = "password";

    # # for podman/aspire
    # subUidRanges = [{ startUid = 100000; count = 65536; }];
    # subGidRanges = [{ startGid = 100000; count = 65536; }];
  };

  # networking.networkmanager.enable = true;
  # networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];

  programs.openvpn3 = {
    enable = true;
  };

  # hardware.openrazer.enable = true; # disabled: openrazer 3.10.3 incompatible with kernel 7.x (hid_report_raw_event signature change)

  home-manager.backupFileExtension = "backup";

  # initially added for claude code vs code extensions
  programs.nix-ld.enable = true;

  home-manager.users.${machine.user} =
    { ... }:
    {
      home.stateVersion = "22.11";
      nixpkgs.config.allowUnfree = true;

      programs.bash = {
        enable = true;
        bashrcExtra = ''
          . /etc/nixos/configs/shell/.bashrc
        '';
      };

      #   home.file.".config/containers/policy.json".text =
      #   ''
      #     {
      #       "default": [
      #         {
      #           "type": "insecureAcceptAnything"
      #         }
      #       ]
      #     }
      #   '';
    };

  virtualisation.docker.enable = true;
  virtualisation.docker.package = stable.docker_29;

  # nscd's upstream unit puts StartLimitIntervalSec in [Service] where systemd
  # ignores it, so rapid restarts (e.g. Tailscale updating resolv.conf at boot)
  # trip the default rate limit and leave the DNS cache dead — which slows
  # every fresh browser lookup. Set the limit in [Unit] where it belongs.
  systemd.services.nscd.unitConfig.StartLimitIntervalSec = 0;
  # virtualisation.podman.enable = true;
  # for podman

  # --- mostly came from hardware-configuration.nix ---

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
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
    depends = [
      "/"
      "/boot"
    ];
    options = [
      "defaults"
      "nofail"
    ];
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

  # thunar stuff. file explorer
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

  # sudo killall quadcastrgb; sudo ~/local-packages/QuadcastRGB/quadcastrgb -u pulse 0057a9 -b 50 -l solid 002700 -b 100;
  # systemd.services.setup-quadcastrgb = {
  #   description = "Sets up colors for microphone using Quadcastrgb";
  #   wantedBy = [ "multi-user.target" ];
  #   path = [ stable.psmisc ]; # used for killall
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = stable.writeShellScript "setup-quadcastrgb" ''
  #       killall quadcastrgb;
  #       /home/one/local-packages/QuadcastRGB/quadcastrgb -u pulse 0057a9 -b 50 -l solid 002700 -b 100;
  #     '';
  #     RemainAfterExit = true;
  #   };
  # };

}
