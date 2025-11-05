{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi = {
      efiSysMountPoint = "/efi";
      canTouchEfiVariables = true;
    };
    timeout = 5;
  };

  hardware.amdgpu = {
    overdrive.enable = true;
    initrd.enable = true;
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.lact.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "firewake";
  networking.networkmanager.enable = true;
  services.resolved.enable = true;

  services.sing-box = {
    enable = true;
    settings = inputs.secrets.singBoxConfig;
  };

  time.timeZone = "Asia/Vladivostok";

  i18n.defaultLocale = "ru_RU.UTF-8";

  console = {
    font = "ter-c32b";
    packages = with pkgs; [ terminus_font ];
    keyMap = "ru";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.fish.enable = true;
  security.sudo.wheelNeedsPassword = false;
  users.users.vinso = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    helix
    nixd
    nixfmt

    git
    wget

    # Niri
    fuzzel
    mako
    xwayland-satellite
    pavucontrol
    ddcutil
    playerctl
    libnotify

    # to test polkitagent
    gparted

    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
  ];

  #Niri and deps
  programs.niri.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  hardware.i2c.enable = true;

  networking.firewall.enable = false;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  home-manager.users.vinso = {
    programs.fastfetch.enable = true;
  };
}
