{ pkgs, ... }:

let
  scripts = {
    toggle-microphone = pkgs.callPackage ./scripts/toggle-microphone.nix { };
    toggle-audio = pkgs.callPackage ./scripts/toggle-audio.nix { };
    ddc-brightness = pkgs.callPackage ./scripts/ddc-brightness.nix { };
  };
in
{
  home.packages = with pkgs; [
    wl-clipboard
    libnotify
    wev
    playerctl
    hyprshot
    ddcutil
    scripts.toggle-microphone
    scripts.toggle-audio
    scripts.ddc-brightness
  ];
  # Required for env variables to be exported to hyprland.
  programs.bash.enable = true;
  services.hyprpolkitagent.enable = true;

  wayland.windowManager.hyprland.enable = true;

  wayland.windowManager.hyprland.extraLuaFiles = {
    "config".content = ./configs/config.lua;
    "autostart".content = ./configs/autostart.lua;
    "windowrules".content = ./configs/windowrules.lua;
    "animations".content = ./configs/animations.lua;
    "binds".content = ./configs/binds.lua;
  };
}
