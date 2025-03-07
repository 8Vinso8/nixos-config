{
  pkgs,
  config,
  ...
}:

{
  programs.spotify-player = {
    enable = true;
    package = (pkgs.spotify-player.override {
      withAudioBackend = "pulseaudio";
    });
    settings = {
      device = {
        audio_cache = true;
        volume = 100;
        device_type = "computer";
        autoplay = true;
        name = "${config.networking.hostName}";
      };
    };
  };
}
