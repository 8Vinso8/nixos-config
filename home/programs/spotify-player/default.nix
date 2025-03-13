{
  pkgs,
  hostname,
  ...
}:

{
  programs.spotify-player = {
    enable = true;
    package = (pkgs.spotify-player.override {
      withAudioBackend = "pulseaudio";
      withNotify = false;
    });
    settings = {
      default_device = "${hostname}";
      playback_refresh_duration_in_ms = 1000;
      device = {
        audio_cache = true;
        volume = 100;
        device_type = "computer";
        autoplay = true;
        name = "${hostname}";
      };
    };
  };
}
