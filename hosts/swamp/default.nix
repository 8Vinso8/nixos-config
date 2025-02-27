{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default.nix
    ../../modules/sdboot
    ../../modules/silentBoot.nix
    ../../modules/sing-box.nix
    ../../modules/fonts
    ../../modules/features/bluetooth
    ../../modules/services/pipewire.nix
  ];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  networking.hostName = "swamp";
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  environment.systemPackages = with pkgs; [
    kdePackages.sddm-kcm
  ];
  system.stateVersion = "24.11";
}
