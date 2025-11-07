{ ... }:

{
  home-manager.users.vinso = {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "bottom";
          position = "bottom";
          spacing = 4;

          modules-left = [
            "niri/workspaces"
            "hyprland/workspaces"
          ];
          modules-center = [ "clock" ];
          modules-right = [
            "idle_inhibitor"
            "niri/language"
            "hyprland/language"
            "pulseaudio"
            "cpu"
            "memory"
            "custom/brightness"
            "tray"
          ];

          "custom/brightness" = {
            exec = "cat ~/.config/last_brightness";
            format = "br:{}%";
            interval = 5;
          };

          idle_inhibitor = {
            format = "idle";
            tooltip = false;
          };

          tray.spacing = 5;

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

          cpu = {
            format = "cpu:{usage}%";
            tooltip = false;
          };

          memory = {
            format = "mem:{}%";
          };

          pulseaudio = {
            format = "{format_source}";
            format-source = "mic";
            format-source-muted = "MIC";
            tooltip = false;
          };

          "niri/language" = {
            format-en = "EN";
            format-ru = "RU";
          };
        };
      };
    };
  };
}
