{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default.nix
    ../../modules/amdgpu
    ../../modules/programs/corectrl.nix
    ../../modules/services/pipewire.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
        editor = false;
      };
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
    consoleLogLevel = 0;
    initrd = {
      verbose = false;
    };
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    plymouth.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  networking = {
    hostName = "firewake";
    firewall.enable = false;
    interfaces.enp4s0.wakeOnLan.enable = true;
  };

  services = {
    getty.autologinUser = "vinso";
    pipewire.configPackages = [
      (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-split-input.conf" (
        builtins.readFile ./10-split-input.conf
      ))
    ];
    sing-box = {
      enable = true;
      settings = builtins.fromJSON (inputs.secrets.singBoxConfig);
    };
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
      ExecStart = "/bin/sh -c 'echo GPP0 > /proc/acpi/wakeup'";
    };
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };

  users.users.vinso = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "adbusers"
    ];
    shell = pkgs.fish;
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
      withUWSM = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs: [ pkgs.kdePackages.breeze ];
      };
      protontricks.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    dconf.enable = true;
    fish.enable = true;
    adb.enable = true;
  };

  system.stateVersion = "24.11";
}
