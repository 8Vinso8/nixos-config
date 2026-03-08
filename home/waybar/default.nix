{ ... }:

{
  programs.waybar.enable = true;
  programs.waybar.style = ./style.css;
  programs.waybar.settings = {
    mainBar = {
      layer = "bottom";
      position = "bottom";
      spacing = 0;
      height = 16;

      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [
        "custom/ddc-brightness"
        "idle_inhibitor"
        "hyprland/language"
        "pulseaudio"
        "tray"
      ];

      idle_inhibitor = {
        format = "idle";
        tooltip = false;
      };

      tray = {
        spacing = 10;
      };

      clock = {
        format = "{:L%H:%M  %a %d.%m.%Y}";
        locale = "ru_RU.UTF-8";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "year";
          mode-mon-col = 3;
          weeks-pos = "right";
          on-scroll = 1;
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            days = "<span color='#ecc6d9'><b>{}</b></span>";
            weeks = "<span color='#99ffdd'><b>W{}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };
        actions = {
          on-click-right = "mode";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };

      pulseaudio = {
        format = "sound  {format_source}";
        format-muted = "<span foreground=\"#F38BA8\">sound</span>  {format_source}";
        format-source = "mic";
        format-source-muted = "<span foreground=\"#F38BA8\">mic</span>";
        tooltip = false;
      };

      "hyprland/language" = {
        format-en = "en";
        format-ru = "ru";
      };

      "custom/ddc-brightness" = {
        exec = "cat /home/vinso/.config/last_brightness";
        format = "{}";
        signal = 8;
      };
    };
  };
}
