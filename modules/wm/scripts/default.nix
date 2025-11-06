{ pkgs, ... }:

{
  home-manager.users.vinso = {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "ddcci-brightness";
        runtimeInputs = [
          pkgs.libnotify
          pkgs.ddcutil
        ];
        text = ''
          ddcutil --bus 7 --skip-ddc-checks --sleep-multiplier=.1 setvcp 10 "$@"
          value=$(ddcutil --bus 7 --skip-ddc-checks --sleep-multiplier=.1 --brief getvcp 10 | grep -oP "C \K\d+")
          echo "$value" > ~/.config/last_brightness
          notify-send Brightness "$value" -h string:x-canonical-private-synchronous:osd
        '';
      })
      (pkgs.writeShellApplication {
        name = "toggle-microphone";
        runtimeInputs = [
          pkgs.wireplumber
          pkgs.libnotify
        ];
        text = ''
          wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
          if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -qF "[MUTED]"; then
            notify-send -h string:x-canonical-private-synchronous:osd Mic "<span color='red'>MUTED</span>"
          else
            notify-send -h string:x-canonical-private-synchronous:osd Mic "<span color='green'>UNMUTED</span>"
          fi
        '';
      })
    ];
  };
}
