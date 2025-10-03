{ pkgs, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    wayland.compositor = "kwin";
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;
}
