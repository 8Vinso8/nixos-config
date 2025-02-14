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
        layer = "bottom";
        position = "top";
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "cpu"
          "memory"
          "disk"
          "hyprland/language"
          "tray"
        ];
        "hyprland/workspaces" = {
          persistent-workspaces = {
            "*" = 8;
          };
        };
        "hyprland/language" = {
          format-en = "EN";
          format-ru = "RU";
        };
        cpu = {
          format = "CPU: {usage}%";
        };
        disk = {
          format = "DISK (/): {specific_used:0.2f} GiB / {specific_total:0.2f} GiB ({percentage_used}%)";
          unit = "GiB";
          tooltip = false;
        };
        memory = {
          format = "RAM: {used} GiB / {total} GiB ({percentage}%)";
          tooltip-format = "SWAP: {swapUsed} GiB / {swapTotal} GiB ({swapPercentage}%)";
        };
        tray = {
         spacing = 5;
        };
        clock = {
          format = "{:%H:%M  %d.%m.%y}";
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
