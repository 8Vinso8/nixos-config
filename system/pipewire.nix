{ ... }:

{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  users.users.vinso.extraGroups = [ "pipewire" ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire = {
      "92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [
            44100
            48000
          ];
          "default.clock.quantum" = 2048;
          "default.clock.min-quantum" = 1024;
          "default.clock.max-quantum" = 4096;
        };
      };
    };
    wireplumber.extraConfig = {
      "50-alsa-config" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "~alsa_input.*";
              }
              {
                "node.name" = "~alsa_output.*";
              }
            ];
            actions = {
              update-props = {
                "session.suspend-timeout-seconds" = 0;
              };
            };
          }
          {
            matches = [
              {
                "node.name" = "alsa_output.pci-0000_09_00.4.analog-stereo";
              }
            ];
            actions = {
              update-props = {
                "api.alsa.headroom" = 1024;
              };
            };
          }
        ];
      };
    };
  };

  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0 power_save_controller=N position_fix=1
  '';

  systemd.user.services.pipewire.wantedBy = [ "default.target" ];
  systemd.user.services.pipewire-pulse.wantedBy = [ "default.target" ];
}
