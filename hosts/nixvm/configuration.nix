{
  pkgs,
  ...
}:

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
  boot.blacklistedKernelModules = [ "i6300esb" "softdog" "iTCO_wdt" ];

  services.qemuGuest.enable = true;

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

  programs.firefox.enable = true;

  programs.nix-ld.enable = true;
}
