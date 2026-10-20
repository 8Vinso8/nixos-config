{
  writeShellApplication,
  cliphist,
  rofi,
  wl-clipboard,
}:
writeShellApplication {
  name = "rofi-clipboard";
  runtimeInputs = [
    cliphist
    rofi
    wl-clipboard
  ];
  text = ''
    selection="$(cliphist list | rofi -dmenu \
        -theme "$HOME/.config/rofi/clipboard.rasi" \
        -no-custom \
        -p Clipboard \
        -display-columns 2)" || exit 0

    [[ -n "$selection" ]] || exit 0

    printf '%s\n' "$selection" | cliphist decode | wl-copy
  '';
}
