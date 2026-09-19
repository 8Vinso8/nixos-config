{ pkgs, ... }:

{
  hardware.i2c.enable = true;
  users.users.vinso.extraGroups = [ "i2c" ];

  systemd.services.restore-ddc = {
    description = "Restore ddc brightness after sleep";
    after = [
      "suspend.target"
      "hybrid-sleep.target"
      "hibernate.target"
    ];
    wantedBy = [
      "sleep.target"
    ];
    serviceConfig.Type = "simple";
    script = ''
      sleep 3; ${pkgs.ddcutil}/bin/ddcutil setvcp 10 $(cat /home/vinso/.config/last_brightness)
    '';
  };
}
