{
  writeShellApplication,
  libnotify,
  wireplumber,
}:
writeShellApplication {
  name = "toggle-audio.sh";
  runtimeInputs = [
    libnotify
    wireplumber
  ];
  text = ''
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -qF "[MUTED]"; then
      notify-send -h string:x-canonical-private-synchronous:osd Audio "<span color='red'>MUTED</span>"
    else
      notify-send -h string:x-canonical-private-synchronous:osd Audio "<span color='green'>UNMUTED</span>"
    fi
  '';
}
