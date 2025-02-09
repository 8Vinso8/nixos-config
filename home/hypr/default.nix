{
  ...
}:
{
  imports = [
    ./waybar.nix
  ];
  programs.fish.loginShellInit = ''
    if uwsm check may-start -q;
      and test (tty) = /dev/tty1;
      and test -z $DISPLAY;
      exec uwsm start hyprland-uwsm.desktop
    end
  '';

  programs.kitty.enable = true;
  programs.fuzzel.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    extraConfig = builtins.readFile ./configs/hyprland.conf;
    settings = { 
      monitor = [
        "DP-1, 2560x1440@165, 0x0, 1"
        " , preferred, auto, 1"
      ];
      exec-once = [
        "uwsm app -- waybar"
      ];
      "$terminal" = "kitty";
      "$fileManager" = "yy";
      "$menu" = "fuzzel --launch-prefix='uwsm app -- '";
      "$mainMod" = "SUPER";
      general = {
        border_size = 2;
        no_border_on_floating = true;
        gaps_in = 5;
        gaps_out = 10;
        "col.inactive_border" = "rgba(595959aa)";
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        layout = "master";
      };
      decoration = {
        rounding = 5;
        blur = {
          enabled = false;
        };
        shadow = {
          enabled = false;
        };
      };
      animations = {
        enabled = false;
      };
      input = {
        kb_layout = "us,ru";
        kb_options = "grp:caps_toggle";
        numlock_by_default = true;
        repeat_rate = 35;
        repeat_delay = 450;
        sensitivity = 0.0;
        accel_profile = "flat";
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        vrr = 2;
        key_press_enables_dpms = true;
      };
      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "workspace 8 silent,class:discord"
        "workspace 9 silent,class:spotify"
      ];
    };
  };
}
