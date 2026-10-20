{
  writeShellApplication,
  rofi,
  systemd,
  hyprland,
}:
writeShellApplication {
  name = "rofi-powermenu";
  runtimeInputs = [
    rofi
    systemd
    hyprland
  ];
  text = ''
    shutdown="⏻  Shutdown"
    reboot="󰜉  Reboot"
    sleep="󰒲  Sleep"
    logout="󰍃  Logout"

    options="$shutdown\n$reboot\n$sleep\n$logout"

    chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power") || exit 0
    [[ -n "$chosen" ]] || exit 0

    case "$chosen" in
        "$shutdown")
            systemctl poweroff
            ;;
        "$reboot")
            systemctl reboot
            ;;
        "$sleep")
            systemctl suspend
            ;;
        "$logout")
            hyprctl dispatch 'hl.dsp.exit()'
            ;;
    esac
  '';
}
