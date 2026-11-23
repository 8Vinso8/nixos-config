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
          # Lock rate to 48kHz: prevents ALSA sink re-init and dynamic
          # quantum scaling when mixing 44.1kHz (fooyin) with 48kHz (games/browser)
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [ 48000 ];
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 512;
          "default.clock.max-quantum" = 2048;
        };
      };
    };
    wireplumber.extraConfig = {
      "50-alsa-config" = {
        "monitor.alsa.rules" = [
          # Realtek ALC887 (PCIe onboard audio):
          # On AMD AM4 chipsets, timer-based scheduling (tsched) suffers from DMA pointer
          # jitter under load, causing false XRUNs. Switch to hardware IRQ scheduling.
          # period-size 512 (~10.7ms) with triple buffering (period-num 3, ~32ms total) ensures stability.
          {
            matches = [
              {
                "node.name" = "~alsa_output.pci-.*";
              }
            ];
            actions = {
              update-props = {
                # Keep PCI codec and DMA active during silence to prevent unpause pops/delays
                "session.suspend-timeout-seconds" = 0;
                "node.pause-on-idle" = false;
                "api.alsa.disable-tsched" = true;
                "api.alsa.period-size" = 512;
                "api.alsa.period-num" = 3;
              };
            };
          }
          # Burr-Brown USB DAC:
          # Disabling suspend entirely (0) causes background USB polling XRUNs.
          # Soft 300s timeout eliminates pause clicks while allowing DAC sleep on long idle.
          {
            matches = [
              {
                "node.name" = "~alsa_output.usb-.*";
              }
            ];
            actions = {
              update-props = {
                "session.suspend-timeout-seconds" = 300;
              };
            };
          }
        ];
      };
    };
  };

  # Disable HDA Intel power saving to prevent power-state transition clicks
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0 power_save_controller=N
  '';

  # Autostart pipewire to prevent errors from fooyin on boot
  systemd.user.services = {
    pipewire.wantedBy = [ "default.target" ];
    pipewire-pulse.wantedBy = [ "default.target" ];
    wireplumber.wantedBy = [ "default.target" ];
  };
}
