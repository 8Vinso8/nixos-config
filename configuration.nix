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
    ./system/ddc-restore.nix
    ./system/fonts.nix
    ./system/hdd-sleep.nix
    ./system/hyprland.nix
    ./system/network.nix
    ./system/nix-settings.nix
    ./system/nowatchdog.nix
    .system/time.nix
    ./system/pipewire.nix
    ./system/swap.nix
  ];

  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
  boot.initrd.systemd.enable = true;

  # Fix sleep on Gigabyte B550 mb
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:00:01.1", ATTR{power/wakeup}="disabled"
  '';

  programs.fish.enable = true;
  users.users.vinso = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "vinso";
    extraGroups = [ "wheel" ];
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

  services.power-profiles-daemon.enable = true;



  i18n.defaultLocale = "ru_RU.UTF-8";

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  documentation.nixos.enable = false;

  system.stateVersion = "${stateVersion}";
}
