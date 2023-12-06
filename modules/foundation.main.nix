{ stable, name, ... }:
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
    roboto-mono
  ];

  users.users.${name} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner" "docker" ];
    initialPassword = "password";
  };

  home-manager.users.${name} = { ... }: {
    home.stateVersion = "22.11";
    nixpkgs.config.allowUnfree = true;

    programs.bash = {
      enable = true;
      bashrcExtra = ''
        . /etc/nixos/configs/shell/.bashrc
      '';
    };
  };


  security.sudo = {
    extraRules = [
      {
        users = [ name ];
        commands = [
          { 
            command = "/etc/profiles/per-user/one/bin/ranger"; 
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };

  virtualisation.docker.enable = true;
}