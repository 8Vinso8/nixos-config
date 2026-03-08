{
  writeShellApplication,
  libnotify,
  wireplumber,
}:
writeShellApplication {
  name = "toggle-microphone.sh";
  runtimeInputs = [
    libnotify
    wireplumber
  ];
  text = ''
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -qF "[MUTED]"; then
      notify-send -h string:x-canonical-private-synchronous:osd Mic "<span color='red'>MUTED</span>"
    else
      notify-send -h string:x-canonical-private-synchronous:osd Mic "<span color='green'>UNMUTED</span>"
    fi
  '';
}
