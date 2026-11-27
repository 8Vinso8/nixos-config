{ ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.extraConfig = {
      "50-alsa-config" = {
        "monitor.alsa.rules" = [
          # Realtek ALC887 (PCIe onboard audio): keep active to prevent unpause pops
          {
            matches = [
              {
                "node.name" = "~alsa_output.pci-.*";
              }
            ];
            actions = {
              update-props = {
                "session.suspend-timeout-seconds" = 0;
              };
            };
          }
          # Burr-Brown USB DAC:
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

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="08bb", TEST=="power/control", ATTR{power/control}="on"
  '';

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
