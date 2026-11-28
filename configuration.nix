{
  pkgs,
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
    ./system/pipewire.nix
    ./system/swap.nix
    ./system/gaming.nix
  ];

  nixpkgs.overlays = [
    (import ./pkgs)
  ];

  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  hardware.i2c.enable = true;

  services.udev.packages = [ pkgs.boxflat ];

  services.udev.extraRules = ''
    # Fix sleep on Gigabyte B550 motherboard
    ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:00:01.1", ATTR{power/wakeup}="disabled"

    # Moza Racing - disable fuzz and deadzone for raw 0-100% precision
    ACTION=="add", SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT_JOYSTICK}=="1", ATTRS{idVendor}=="346e", ATTRS{idProduct}=="0004", RUN+="${pkgs.linuxConsoleTools}/bin/evdev-joystick --evdev %E{DEVNAME} --fuzz 0 --deadzone -0"
  '';

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

  programs.nix-ld.enable = true;
  programs.dconf.enable = true;

  services.udisks2.enable = true;
  services.fstrim.enable = true;

  documentation.nixos.enable = false;

  time.timeZone = "Asia/Vladivostok";
  i18n.defaultLocale = "ru_RU.UTF-8";

  fileSystems."/".options = [ "noatime" ];

  system.stateVersion = stateVersion;
}
