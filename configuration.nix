{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];
  zramSwap.enable = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "amdgpu.ppfeaturemask=0xfffd7fff"
      "video=DP-1:2560x1440@165"
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];
    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        configurationLimit = 5;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };
    plymouth = {
      enable = true;
      theme = "bgrt";
    };
    initrd.systemd.enable = true;
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  networking = {
    hostName = "firewake";
    networkmanager.enable = true;
    timeServers = [ "openwrt.lan" ];
    firewall.enable = false;
  };

  services = {
    resolved.enable = true;
    scx = {
      enable = true;
      scheduler = "scx_lavd";
    };
    xserver = {
      enable = true;
      xkb.layout = "us,ru";
      videoDrivers = [ "amdgpu" ];
    };
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-split-input.conf" (
          builtins.readFile ./10-split-input.conf
        ))
      ];
    };
    sing-box = {
      enable = true;
      settings = builtins.fromJSON (inputs.secrets.singBoxConfig);
    };
  };

  systemd = {
    packages = [ pkgs.lact ];
    services = {
      BiosSleepFix = {
        enable = true;
        description = "Gigabyte B550 F12 bios sleep bug workaround";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = "yes";
          ExecStart = "/bin/sh -c 'if grep 'GPP0' /proc/acpi/wakeup | grep -q 'enabled'; then echo 'GPP0' > /proc/acpi/wakeup; fi'";
        };
      };
      lactd.wantedBy = [ "multi-user.target" ];
    };
  };

  time.timeZone = "Asia/Vladivostok";

  i18n.defaultLocale = "ru_RU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  users.users.vinso = {
    isNormalUser = true;
    description = "Vinso";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  programs = {
    adb.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      extraPackages = with pkgs; [
        kdePackages.breeze
      ];
    };
    fish.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    optimise = {
      automatic = true;
      dates = [ "daily" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  environment = {
    variables = {
      VDPAU_DRIVER = "radeonsi";
    };
    systemPackages = with pkgs; [
      git
      lact
      kdePackages.sddm-kcm
    ];
    plasma6.excludePackages = with pkgs.kdePackages; [
      konsole
    ];
  };

  system.stateVersion = "24.11";
}
