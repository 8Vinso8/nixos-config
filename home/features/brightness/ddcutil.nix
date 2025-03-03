{
  ...
}:

{
  wayland.windowManager.hyprland = {
    extraConfig = ''
      bind = $mainMod, bracketright, exec, for bus in $(cat /run/monitor_i2c_buses); do ddcutil --noverify -b $bus setvcp 10 + 10; notify-send -h string:x-canonical-private-synchronous:brightness ' ' -h int:value:$(ddcutil -b $bus getvcp 10 | grep -oP 'current value =\s+\K\d+'); done
      bind = $mainMod, bracketleft, exec, for bus in $(cat /run/monitor_i2c_buses); do ddcutil --noverify -b $bus setvcp 10 - 10; notify-send -h string:x-canonical-private-synchronous:brightness ' ' -h int:value:$(ddcutil -b $bus getvcp 10 | grep -oP 'current value =\s+\K\d+'); done
    '';
  };
}
