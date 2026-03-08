{ ... }:

{
  xdg.configFile."wall.png".source = ./wall.png;
  services.hyprpaper.enable = true;
  services.hyprpaper.settings = {
    splash = false;

    wallpaper = [
      {
        monitor = "DP-1";
        path = "/home/vinso/.config/wall.png";
      }
    ];
  };
}
