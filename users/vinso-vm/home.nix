{ stateVersion, pkgs, inputs, ... }:

{
  home.username = "vinso";
  home.homeDirectory = "/home/vinso";

  imports = [
    ../../home
    inputs.zen-browser.homeModules.beta
  ];

  home.packages = with pkgs; [
    nixd
    nixfmt

    goverlay
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "Virtual-1, 2048x1152@60, 0x0, 1"
    ]; 
  };

  programs.fastfetch.enable = true;

  programs.zen-browser.enable = true;

  home.stateVersion = "${stateVersion}";
}
