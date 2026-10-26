{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard
    libnotify
    wev
    playerctl
    hyprshot
    ddcutil
    cliphist
    hyprland-per-window-layout
    ddc-brightness
    toggle-audio
    toggle-microphone
    sinkchange
  ];
  # Required for env variables to be exported to hyprland.
  programs.bash.enable = true;
  services.hyprpolkitagent.enable = true;

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${config.xdg.configHome}/wallpapers/gemini.jpg" ];
      wallpaper = {
        monitor = "DP-1";
        path = "${config.xdg.configHome}/wallpapers/gemini.jpg";
        fit_mode = "cover";
      };
      splash = false;
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      listener = [
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  wayland.windowManager.hyprland.enable = true;

  wayland.windowManager.hyprland.extraLuaFiles = {
    "config".content = ./configs/config.lua;
    "autostart".content = ./configs/autostart.lua;
    "windowrules".content = ./configs/windowrules.lua;
    "animations".content = ./configs/animations.lua;
    "binds".content = ./configs/binds.lua;
    "envvars".content = ./configs/envvars.lua;
  };

  xdg.configFile."wallpapers/gemini.jpg".source = ../wallpapers/gemini.jpg;

  xdg.configFile."cliphist/config".text = "preview-width 120\n";
}
