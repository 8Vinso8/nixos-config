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
    ../../modules/features/openssh
    ../../modules/features/bluetooth
    ../../modules/features/wayland
    ../../modules/services/pipewire.nix
    ../../modules/programs/hyprland.nix
    ../../modules/programs/corectrl.nix
    ../../modules/programs/steam.nix
  ];
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
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
    pipewire.configPackages = [
      (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-split-input.conf" (
        builtins.readFile ./10-split-input.conf
      ))
    ];
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
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      jetbrains-mono
      nerd-fonts.jetbrains-mono
    ];
  };
  programs.adb.enable = true;
  system.stateVersion = "24.11";
}
