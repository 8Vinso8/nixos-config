{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./waybar.nix
    ../programs/mako
    ./hypridle.nix
  ];

  home.packages = with pkgs; [ 
    playerctl
    wev
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    hyprpolkitagent
  ];

  services.playerctld.enable = true;

  programs.fish.loginShellInit = ''
    if uwsm check may-start -q;
      and test (tty) = /dev/tty1;
      and test -z $DISPLAY;
      exec uwsm start -S hyprland-uwsm.desktop 
    end
  '';

  programs.kitty.enable = true;
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        use-bold = "yes";
        anchor = "top";
        lines = 5;
        width = 25;
        tabs = 2;
        horizontal-pad = 10;
        vertical-pad = 5;
      };
      colors = {
        background = "00000022";
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    settings = {
      monitor = [
        "DP-1, 2560x1440@165, 0x0, 1"
        " , preferred, auto, 1"
      ];
      exec-once = [
        "systemctl --user start hyprpolkitagent.service"
      ];
      "$menu" = "fuzzel --launch-prefix='uwsm app -- '";
      "$mainMod" = "SUPER";
      general = {
        border_size = 3;
        no_border_on_floating = false;
        gaps_in = 5;
        gaps_out = 10;
        "col.inactive_border" = "rgba(00000000)";
        "col.active_border" = "rgba(33ccffee)";
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
        repeat_rate = 35;
        repeat_delay = 450;
        sensitivity = 0.0;
        accel_profile = "flat";
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        background_color = "0x000000";
        vrr = 2;
        key_press_enables_dpms = true;
      };
      master = {
        mfact = 0.70;
        orientation = "right";

      };
      workspace = [
        # no gaps when only
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];
      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "workspace 8 silent, class:discord"
        "workspace 7 silent, class:spotify"
        "nofocus, class:^$, title:^$, xwayland:1, floating:1, fullscreen:0, pinned:0"
        "float,class:kitty"
        # no gaps when only
        "bordersize 0, floating:0, onworkspace:w[tv1]"
        "rounding 0, floating:0, onworkspace:w[tv1]"
        "bordersize 0, floating:0, onworkspace:f[1]"
        "rounding 0, floating:0, onworkspace:f[1]"
      ];
      bind = [
        "$mainMod, RETURN, exec, uwsm app -- kitty"
        "$mainMod, C, killactive,"
        "$mainMod, V, togglefloating"
        "$mainMod, D, exec, $menu"
        " , Print, exec, grimblast --freeze copy area"

        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, Q, workspace, 5"
        "$mainMod, W, workspace, 6"
        "$mainMod, E, workspace, 7"
        "$mainMod, R, workspace, 8"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, Q, movetoworkspace, 5"
        "$mainMod SHIFT, W, movetoworkspace, 6"
        "$mainMod SHIFT, E, movetoworkspace, 7"
        "$mainMod SHIFT, R, movetoworkspace, 8"
      ];
      bindi = [
          " , XF86AudioPlay, exec, playerctl play-pause"
          " , XF86AudioNext, exec, playerctl next"
          " , XF86AudioPrev, exec, playerctl previous"
      ];
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
