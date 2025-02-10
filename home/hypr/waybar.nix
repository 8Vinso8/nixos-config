{
  ...
}:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./configs/style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "cpu"
          "clock"
          "disk"
          "hyprland/language"
          "memory"
          "tray"
        ];
        "hyprland/workspaces" = {
          persistent-workspaces = {
            "*" = 8;
          };
        };
        "hyprland-language" = {
          "format-en" = "EN";
          "format-ru" = "RU";
        };
        cpu = {
          format = "CPU:{usage}%";
        };
        clock = {
          format = "{:%Y.%m.%d %H:%M}";
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
        };
      };
    };
  };
}
