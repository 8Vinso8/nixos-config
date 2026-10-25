{
  pkgs,
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

  nixpkgs.overlays = [
    (import ./pkgs)
  ];

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  boot.initrd.systemd.enable = true;

  hardware.i2c.enable = true;

  services.udev.packages = [ pkgs.boxflat ];

  services.udev.extraRules = ''
    # Fix sleep on Gigabyte B550 motherboard
    ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:00:01.1", ATTR{power/wakeup}="disabled"

    # Allow hdd to sleep
    ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ENV{ID_SERIAL}=="${hddSerial}", RUN+="${pkgs.hdparm}/bin/hdparm -B 127 /dev/%k"

    # Moza Racing - disable fuzz and deadzone for raw 0-100% precision
    ACTION=="add", SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT_JOYSTICK}=="1", ATTRS{idVendor}=="346e", ATTRS{idProduct}=="0004", RUN+="${pkgs.linuxConsoleTools}/bin/evdev-joystick --evdev %E{DEVNAME} --fuzz 0 --deadzone -0"
  '';

  systemd.services.hdparm-resume = {
    description = "Reapply hdparm APM setting after sleep";
    after = [
      "suspend.target"
      "hybrid-sleep.target"
      "hibernate.target"
      "suspend-then-hibernate.target"
    ];
    wantedBy = [
      "suspend.target"
      "hybrid-sleep.target"
      "hibernate.target"
      "suspend-then-hibernate.target"
    ];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = "${pkgs.hdparm}/bin/hdparm -B 127 ${hddPath}";
    };
  };

  systemd.services.ddc-restore = {
    description = "Restore monitor brightness after sleep";
    after = [
      "suspend.target"
      "hybrid-sleep.target"
      "hibernate.target"
      "suspend-then-hibernate.target"
    ];
    wantedBy = [
      "suspend.target"
      "hybrid-sleep.target"
      "hibernate.target"
      "suspend-then-hibernate.target"
    ];
    serviceConfig = {
      Type = "oneshot";
      User = "vinso";
      ExecStart = "${pkgs.ddc-brightness}/bin/ddc-brightness restore";
    };
  };

  programs.fish.enable = true;
  security.sudo.wheelNeedsPassword = false;
  users.users.vinso = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "vinso";
    extraGroups = [
      "wheel"
      "i2c"
    ];
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
  programs.dconf.enable = true;

  # Virtual filesystem and automounting for file managers
  services.gvfs.enable = true;

  services.power-profiles-daemon.enable = true;
  services.fstrim.enable = true;

  documentation.nixos.enable = false;

  i18n.defaultLocale = "ru_RU.UTF-8";

  fileSystems."/".options = [ "noatime" ];

  system.stateVersion = stateVersion;
}
