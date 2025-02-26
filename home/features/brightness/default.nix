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
        "$mainMod, bracketright, exec, ddcutil setvcp 10 + 10 && notify-send -h string:x-canonical-private-synchronous:brightness Brightness \"$(ddcutil getvcp 10 | grep -oP 'current value =\\s*\\K\\d+')\""
        "$mainMod, bracketleft, exec, ddcutil setvcp 10 - 10 && notify-send -h string:x-canonical-private-synchronous:brightness Brightness \"$(ddcutil getvcp 10 | grep -oP 'current value =\\s*\\K\\d+')\""
      ];
    };
  };
}
