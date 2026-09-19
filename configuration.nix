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
    ./system/swap.nix
  ];

  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;

  boot.initrd.systemd.enable = true;

  boot.kernelParams = [
    "nowatchdog"
  ];

  boot.blacklistedKernelModules = [ "sp5100_tco" ];

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

  services.power-profiles-daemon.enable = true;

  time.timeZone = "Asia/Vladivostok";

  i18n.defaultLocale = "ru_RU.UTF-8";

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  programs.fish.enable = true;
  users.users.vinso = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "vinso";
    extraGroups = [
      "networkmanager"
      "wheel"
      "realtime"
      "i2c"
    ];
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  documentation.nixos.enable = false;

  system.stateVersion = "${stateVersion}";
}
