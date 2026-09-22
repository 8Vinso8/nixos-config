{
  pkgs,
  inputs,
  stateVersion,
  ...
}:

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

  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
  #boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd.systemd.enable = true;

  hardware.i2c.enable = true;

  # Fix sleep on Gigabyte B550 mb
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:00:01.1", ATTR{power/wakeup}="disabled"
    ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="sdb", RUN+="${pkgs.hdparm}/bin/hdparm -B 127 /dev/sdb"
  '';

  powerManagement.resumeCommands = ''
    ${pkgs.hdparm}/bin/hdparm -B 127 /dev/sdb
    sleep 3; ${pkgs.ddcutil}/bin/ddcutil setvcp 10 $(cat /home/vinso/.config/last_brightness) 
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
    "/home".options = [
      "compress=zstd"
      "noatime"
    ];
    "/nix".options = [
      "compress=zstd"
      "noatime"
    ];
    "/swap".options = [ "noatime" ];
  };

  i18n.defaultLocale = "ru_RU.UTF-8";

  system.stateVersion = "${stateVersion}";
}
