{
  pkgs,
  ...
}:

{
  hardware.i2c.enable = true;
  environment.systemPackages = [ pkgs.ddcutil ]; 
  systemd.services.detect-i2c = {
    description = "Detect Monitor I2C Buses";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.bash + "/bin/bash -c '\
        export I2C_BUSES=\"$(ddcutil detect | awk \"/I2C bus:/ {print \\$3}\" | tr \"\\n\" \" \")\" && \
        systemctl set-environment I2C_BUSES=\"$I2C_BUSES\"'";
    };
  };
}
