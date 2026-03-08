{
  writeShellApplication,
  hyprland,
  jq,
  libnotify
}:
writeShellApplication {
  name = "hypr-change-layout.sh";
  runtimeInputs = [ hyprland jq libnotify ];
  text = ''
    data=$(hyprctl -j activeworkspace)

    id=$(echo "$data" | jq '.id')
    tiledLayout=$(echo "$data" | jq -r '.tiledLayout')
    
    if [ "$tiledLayout" = "master" ]; then
      hyprctl keyword workspace "$id", layout:scrolling
      notify-send "scrolling" -h string:x-canonical-private-synchronous:osd
    else
      hyprctl keyword workspace "$id", layout:master
      notify-send "master" -h string:x-canonical-private-synchronous:osd
    fi
  '';
}
