{
  pkgs,
  inputs,
  stateVersion,
  ...
}:

let
  hddSerial = "WDC_WD10EZEX-60WN4A0_WD-WCC6Y6ED6DH9";
  hddPath = "/dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A0_WD-WCC6Y6ED6DH9";
in
{
  imports = [
    ./hardware-configuration.nix
    ./system/amdgpu.nix
    ./system/boot.nix
    ./system/fonts.nix
    ./system/hyprland.nix
    ./system/network.nix
    ./system/nix-settings.nix
    ./system/nowatchdog.nix
    ./system/time.nix
    ./system/pipewire.nix
    ./system/swap.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd.systemd.enable = true;

  hardware.i2c.enable = true;

  # Fix sleep on Gigabyte B550 mb
  services.udev.extraRules = ''
    # Fix sleep on Gigabyte B550 motherboard
    ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:00:01.1", ATTR{power/wakeup}="disabled"

    # Allow hdd to sleep
    ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ENV{ID_SERIAL}=="${hddSerial}", RUN+="${pkgs.hdparm}/bin/hdparm -B 127 /dev/%k"
  '';

  powerManagement.resumeCommands = ''
    ${pkgs.hdparm}/bin/hdparm -B 127 "${hddPath}"
    sleep 3
    ${pkgs.ddcutil}/bin/ddcutil setvcp 10 $(cat /home/vinso/.config/last_brightness) 
  '';

  programs.fish.enable = true;
  users.users.vinso = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "vinso";
    extraGroups = [ "wheel" "i2c" ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

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

  services.power-profiles-daemon.enable = true;

  documentation.nixos.enable = false;

  fileSystems = {
    "/".options = [
      "compress=zstd"
      "noatime"
    ];
  };

  i18n.defaultLocale = "ru_RU.UTF-8";

  system.stateVersion = "${stateVersion}";
}
