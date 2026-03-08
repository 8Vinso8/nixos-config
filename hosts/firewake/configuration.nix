{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.initrd.verbose = false;
  boot.initrd.systemd.enable = true;

  boot.kernelParams = [
    "quiet"
    "udev.log_level=3"
    "systemd.show_status=auto"
    "nowatchdog"
  ];

  boot.consoleLogLevel = 3;
  boot.blacklistedKernelModules = [ "sp5100_tco" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.lact.enable = true;
  hardware.amdgpu.initrd.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:00:01.1", ATTR{power/wakeup}="disabled"
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

  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };

  programs.hyprland.enable = true;

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "start-hyprland &> /dev/null";
        user = "vinso";
      };
      default_session = initial_session;
    };
  };

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  programs.gamemode.enable = true;

  programs.nix-ld.enable = true;

  # Automount usb in pcmanfm
  services.gvfs.enable = true;

  hardware.i2c.enable = true;
}
