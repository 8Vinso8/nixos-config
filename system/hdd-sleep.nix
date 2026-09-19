{ pkgs, ... }:

{
  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="sdb", RUN+="${pkgs.hdparm}/bin/hdparm -B 127 /dev/sdb"
  '';

  systemd.services.hdparm = {
    description = "Apply hdd params after sleep";
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
      ${pkgs.hdparm}/bin/hdparm -B 127 /dev/sdb
    '';
  };
}
