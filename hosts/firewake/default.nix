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
    ../../modules/programs/corectrl.nix
    ../../modules/services/pipewire.nix
    ../../modules/features/bluetooth
    ../../modules/sing-box.nix
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

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
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

  programs = {
    hyprland = {
      enable = true;
    };
    steam.enable = true;
    dconf.enable = true;
    fish.enable = true;
    adb.enable = true;
  };

  system.stateVersion = "24.11";
}
