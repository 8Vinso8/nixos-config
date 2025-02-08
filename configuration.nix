{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
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
      "amdgpu.seamless=1"
      "video=DP-1:2560x1440@165"
      "quiet"
      "splash"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    plymouth.enable = true;
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu.initrd.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  zramSwap.enable = true;

  networking = {
    hostName = "vinsopc";
    firewall.enable = false;
    networkmanager = {
      enable = true;
    };
    interfaces.enp4s0.wakeOnLan.enable = true;
  };

  services = {
    getty.autologinUser = "vinso";
    resolved.enable = true;
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      xkb = {
        layout = "us,ru";
        options = "grp:caps_toggle";
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-split-input.conf" (
          builtins.readFile ./configs/pipewire/10-split-input.conf
        ))
      ];
    };
    sing-box = {
      enable = true;
      settings = builtins.fromJSON (inputs.secrets.singBoxConfig);
    };
    openssh = {
      enable = true;
      startWhenNeeded = true;
      settings = {
        AllowUsers = [ "vinso" ];
        PermitRootLogin = "no";
      };
    };
  };

  time.timeZone = "Asia/Vladivostok";

  i18n = {
    defaultLocale = "ru_RU.UTF-8";
    extraLocaleSettings = {
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
  };

  console = {
    packages = [ pkgs.terminus_font ];
    font = "ter-c32b";
    useXkbConfig = true;
  };

  environment = {
    variables = {
      VDPAU_DRIVER = "radeonsi";
    };
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
    rtkit.enable = true;
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if ((action.id == "org.corectrl.helper.init" ||
            action.id == "org.corectrl.helperkiller.init") &&
            subject.local == true &&
            subject.active == true &&
            subject.isInGroup("wheel")) {
              return polkit.Result.YES;
          }
        });
      '';
    };
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
    corectrl = {
      enable = true;
      gpuOverclock = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
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

  nixpkgs.config.allowUnfree = true;
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    optimise = {
      automatic = true;
      dates = [ "daily" ];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  system.stateVersion = "24.11";
}
