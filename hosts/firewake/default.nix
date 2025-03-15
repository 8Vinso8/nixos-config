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
    ../../modules/amdgpu
    ../../modules/sing-box.nix
    ../../modules/fonts
    ../../modules/features/openssh
    ../../modules/features/bluetooth
    ../../modules/features/brightness
    ../../modules/services/pipewire.nix
    ../../modules/programs/corectrl.nix
    ../../modules/programs/steam.nix
    ../../modules/programs/hyprland.nix
  ];
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    plymouth.enable = true;
  };
  networking = {
    hostName = "firewake";
    firewall.enable = false;
    interfaces.enp4s0.wakeOnLan.enable = true;
  };
  services = {
    hardware.openrgb.enable = true;
    getty.autologinUser = "vinso";
    getty.autologinOnce = true;
    pipewire.configPackages = [
      (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-split-input.conf" (
        builtins.readFile ./10-split-input.conf
      ))
    ];
    scx.enable = true;
  };
  systemd.services.BiosSleepFix = {
    enable = true;
    description = "Gigabyte B550 F12 bios sleep bug workaround";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "/bin/sh -c 'if grep 'GPP0' /proc/acpi/wakeup | grep -q 'enabled'; then echo 'GPP0' > /proc/acpi/wakeup; fi'";
    };
  };
  programs.adb.enable = true;
  system.stateVersion = "24.11";
}
