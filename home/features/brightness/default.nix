{
  pkgs,
  ...
}:

{
  # WARNING: Requires hardware.i2c.enable = true
  home.packages = [
    pkgs.ddcutil
  ];

  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        "$mainMod, bracketright, exec, ddcutil --noverify --sleep-multiplier 0.1 --skip-ddc-checks setvcp 10 + 10 && notify-send -h string:x-canonical-private-synchronous:brightness \"\" -h int:value:\"$(ddcutil --terse --sleep-multiplier 0.1 getvcp 10 | grep -oP '^(?:\\S+\\s+){3}\\K\\d+')\""
        "$mainMod, bracketleft, exec, ddcutil --noverify --sleep-multiplier 0.1 --skip-ddc-checks setvcp 10 - 10 && notify-send -h string:x-canonical-private-synchronous:brightness \"\" -h int:value:\"$(ddcutil --terse --sleep-multiplier 0.1 getvcp 10 | grep -oP '^(?:\\S+\\s+){3}\\K\\d+')\""
      ];
    };
  };
}
