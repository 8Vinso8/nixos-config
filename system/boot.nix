{ ... }:

{
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
      editor = false;
    };
    efi.canTouchEfiVariables = true;
    timeout = 0;
  };

  boot.kernelModules = [ "ntsync" ];

  services.udev.extraRules = ''
    KERNEL=="ntsync", MODE="0666"
  '';

  boot.consoleLogLevel = 0;

  boot.kernelParams = [
    "fsck.repair=yes"
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    "systemd.show_status=auto"
    "vt.global_cursor_default=0"
  ];
}
