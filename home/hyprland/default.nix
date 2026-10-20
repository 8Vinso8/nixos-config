{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard
    libnotify
    wev
    playerctl
    hyprshot
    ddcutil
    cliphist
    hyprpaper
    hypridle
    hyprland-per-window-layout
    ddc-brightness
    toggle-audio
    toggle-microphone
    sinkchange
    rofi-powermenu
    rofi-clipboard
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
    "envvars".content = ./configs/envvars.lua;
  };

  xdg.configFile."wallpapers/gemini.jpg".source = ../wallpapers/gemini.jpg;

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = /home/vinso/.config/wallpapers/gemini.jpg

    wallpaper {
        monitor = DP-1
        path = /home/vinso/.config/wallpapers/gemini.jpg
        fit_mode = cover
    }

    splash = false
  '';

  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
    }

    listener {
        timeout = 1800
        on-timeout = systemctl suspend
    }
  '';
}
