{
  writeShellApplication,
  libnotify,
  ddcutil,
}:
writeShellApplication {
  name = "ddc-brightness.sh";
  runtimeInputs = [
    ddcutil
    libnotify
  ];
  text = ''
    STEP=10
    CACHE_FILE="/home/vinso/.config/last_brightness"
    BUS=6
    DELAY=0.5

    # Make sure cache file exists
    [ ! -f "$CACHE_FILE" ] && ddcutil getvcp 10 -t --bus "$BUS" | awk '{print $4}' > "$CACHE_FILE"
    CURRENT=$(cat "$CACHE_FILE")

    if [ "$1" == "up" ]; then
      NEW=$(( CURRENT + STEP > 100 ? 100 : CURRENT + STEP ))
    else
      NEW=$(( CURRENT - STEP < 0 ? 0 : CURRENT - STEP ))
    fi 

    echo "$NEW" > "$CACHE_FILE"
    notify-send "Brightness" "$NEW" -h string:x-canonical-private-synchronous:osd
    # Notify waybar
    pkill -RTMIN+8 waybar
    sleep $DELAY
    ddcutil setvcp 10 "$NEW" --bus "$BUS" --noverify
  '';
}
