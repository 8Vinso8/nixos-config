{
  pkgs,
  lib,
  hostname,
  ...
}:

{
  networking.hostName = "${hostname}";
  networking.networkmanager.enable = true;
  networking.timeServers = [ "openwrt.lan" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";

  time.timeZone = "Asia/Vladivostok";
  i18n.defaultLocale = "ru_RU.UTF-8";

  console = {
    font = lib.mkDefault "ter-c32b";
    packages = with pkgs; [ terminus_font ];
    keyMap = "ru";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.sudo.wheelNeedsPassword = false;
  users.users.vinso = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    git
    wget
  ];
  networking.firewall.enable = false;
  system.stateVersion = "25.05";
}
