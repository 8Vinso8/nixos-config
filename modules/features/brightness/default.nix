{
  pkgs,
  ...
}:

{
  hardware.i2c.enable = true;
  environment.systemPackages = [ pkgs.ddcutil ];
  systemd.services.detect-i2c-buses = {
    description = "Detect monitor I2C buses";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart =
        let
          detectScript = pkgs.writeShellScript "detect-i2c-buses" ''
            set -e
            buses=$(${pkgs.ddcutil}/bin/ddcutil --disable-dynamic-sleep detect --brief | grep -oP '/dev/i2c-\K\d+' | tr '\n' ' ')
            echo "''${buses%% }" > /run/monitor_i2c_buses
            chmod 644 /run/monitor_i2c_buses
          '';
        in
        "${detectScript}";
    };
  };
}
