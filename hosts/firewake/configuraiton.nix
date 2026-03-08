{ pkgs, ... }:

{
  imports = [
    ./hardware-configration.nix
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
}
