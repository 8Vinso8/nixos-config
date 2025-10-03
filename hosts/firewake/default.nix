{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  hardware.amdgpu.overdrive.enable = true;
  hardware.amdgpu.initrd.enable = true;
  services.lact.enable = true;

  hardware.i2c.enable = true;

  systemd.services.sleep-fix = {
    enable = true;
    description = "Disable GPP0 to fix gigabyte b550 sleep bug";
    wantedBy = "multi-user.target";
    after = "multi-user.target";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c \"echo GPP0 > /proc/acpi/wakeup\"";
    };
  };

  programs.steam = {
    enable = true;
    extraPackages = [ pkgs.kdePackages.breeze ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
