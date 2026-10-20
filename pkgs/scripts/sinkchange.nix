{
  writeShellApplication,
  pulseaudio,
  libnotify,
}:
writeShellApplication {
  name = "sinkchange";
  runtimeInputs = [
    pulseaudio
    libnotify
  ];
  text = ''
    HEADPHONES="alsa_output.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo-output"
    SPEAKERS="alsa_output.pci-0000_09_00.4.analog-stereo"

    current=$(pactl get-default-sink)

    if [[ "$current" == "$HEADPHONES" ]]; then
      pactl set-default-sink "$SPEAKERS"
      notify-send -h string:x-canonical-private-synchronous:osd Audio "🔊 Speakers"
    else
      pactl set-default-sink "$HEADPHONES"
      notify-send -h string:x-canonical-private-synchronous:osd Audio "🎧 Headphones"
    fi
  '';
}
