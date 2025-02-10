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
        modules-right = [ "cpu" "clock" "disk" "hyprland/language" "memory" "tray" ];
      };
    };
  };
}
