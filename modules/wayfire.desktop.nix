{ pkgs, services, ... }:
{
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
    wlr = {
      enable = true;
    };
  }; # required for wlroots based desktops

  environment.systemPackages = with pkgs; [
    vim
    wget
    wayfire
    wlr-randr # get output of monitors on wayland
  ]
}