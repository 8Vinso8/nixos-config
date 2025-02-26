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
        "$mainMod, ], exec, ddcutil setvcp 10 + 10"
        "$mainMod, [, exec, ddcutil setvcp 10 - 10"
      ];
    };
  };
}
