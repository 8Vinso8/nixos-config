{
  config,
  inputs,
  pkgs,
  ...
}:

{
  programs.waybar.enable = true;
  programs.waybar.package = inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.waybar;
  programs.waybar.style = ./style.css;
  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 24;
      margin-top = 6;
      margin-left = 8;
      margin-right = 8;
      spacing = 4;

      modules-left = [
        "hyprland/workspaces"
        "hyprland/window"
      ];
      modules-center = [
        "clock"
      ];
      modules-right = [
        "mpris"
        "group/system"
        "tray"
      ];

      mpris = {
        player = "fooyin";
        format = "<span color='#cba6f7'>󰎈</span> {dynamic}";
        format-paused = "<span color='#a6adc8'>󰏤 <i>{dynamic}</i></span>";
        format-stopped = "";
        dynamic-order = [
          "title"
          "artist"
        ];
        max-length = 60;
        on-click = "play-pause";
        on-click-right = "fooyin & hyprctl dispatch \"hl.dsp.focus({ window = 'class:org.fooyin.fooyin' })\"";
        on-scroll-up = "playerctl -p fooyin next";
        on-scroll-down = "playerctl -p fooyin previous";
        tooltip-format = "󰎈 {title}\n󰠃 {artist}\n󰀥 {album}\n󰥔 {position} / {length}";
      };

      "group/system" = {
        orientation = "horizontal";
        modules = [
          "idle_inhibitor"
          "custom/ddc-brightness"
          "hyprland/language"
          "pulseaudio"
        ];
      };

      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "󰒳";
          deactivated = "󰒲";
        };
        tooltip = false;
      };

      "hyprland/workspaces" = {
        format = "{name}";
        tooltip = false;
        persistent-workspaces = {
          "*" = 5;
        };
      };

      "hyprland/window" = {
        format = "{}";
        separate-outputs = true;
        max-length = 40;
      };

      tray = {
        spacing = 8;
        icons = {
          "io.github.lawstorant.boxflat" = "${config.xdg.configHome}/icons/boxflat/steering-wheel.png";
          "Boxflat" = "${config.xdg.configHome}/icons/boxflat/steering-wheel.png";
        };
      };

      clock = {
        format = "<span color='#cba6f7'>󰥔</span> {0:L%H:%M}  <span color='#cba6f7'>󰸗</span> {0:L%a %d.%m.%Y}";
        locale = "ru_RU.UTF-8";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "year";
          mode-mon-col = 3;
          weeks-pos = "right";
          on-scroll = 1;
          format = {
            months = "<span color='#cba6f7'><b>{}</b></span>";
            days = "<span color='#cdd6f4'><b>{}</b></span>";
            weeks = "<span color='#94e2d5'><b>W{}</b></span>";
            weekdays = "<span color='#f9e2af'><b>{}</b></span>";
            today = "<span color='#f38ba8'><b><u>{}</u></b></span>";
          };
        };
        actions = {
          on-click-right = "mode";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };

      pulseaudio = {
        format = "<span color='#cba6f7'>󰕾</span>  {format_source}";
        format-muted = "<span color='#f38ba8'>󰝟</span>  {format_source}";
        format-source = "<span color='#cba6f7'>󰍬</span>";
        format-source-muted = "<span color='#f38ba8'>󰍭</span>";
        tooltip = false;
        on-click = "pavucontrol";
        on-click-right = "toggle-audio";
        on-click-middle = "toggle-microphone";
      };

      "hyprland/language" = {
        format-en = "<span color='#cba6f7'>󰌌</span> EN";
        format-ru = "<span color='#cba6f7'>󰌌</span> RU";
        tooltip = false;
      };

      "custom/ddc-brightness" = {
        exec = "ddc-brightness status";
        return-type = "json";
        format = "<span color='#cba6f7'>{icon}</span> {percentage}%";
        format-icons = [
          "󰃞"
          "󰃝"
          "󰃟"
          "󰃠"
        ];
        signal = 8;
        on-scroll-up = "ddc-brightness up";
        on-scroll-down = "ddc-brightness down";
        tooltip = false;
      };
    };
  };
}
