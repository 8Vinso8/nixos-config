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
