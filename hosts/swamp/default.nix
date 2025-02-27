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
  system.stateVersion = "24.11";
}
