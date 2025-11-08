{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/options

    ./modules/adwaita.nix
    ./modules/fonts.nix

    ./modules/shell

    ./modules/wm/niri
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

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16 GB
    }
  ];

  boot.kernel.sysfs = {
    module.zswap.parameters = {
      enabled = true;
      shrinker_enabled = true;
      max_pool_percent = 20;
      compressor = "zstd";
      zpool = "zsmalloc";
      accept_threshold_percent = 90;
    };
  };

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  # GPP0 disable to fix sleep
  services.udev.extraRules = ''
    ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x1022" ATTR{device}=="0x1483" ATTR{power/wakeup}="disabled"
  '';

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
  networking.firewall.enable = false;

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

  security.sudo.wheelNeedsPassword = false;
  users.users.vinso = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "i2c"
      "network"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    wget

    # brightness control
    ddcutil

  ];

  # To control brightness with ddcutil
  hardware.i2c.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = "${pkgs.tuigreet}/bin/tuigreet -r --remember-session";
      };
    };
  };

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  home-manager.users.vinso = {
    imports = [
      inputs.zen-browser.homeModules.beta
    ];

    home.username = "vinso";
    home.homeDirectory = "/home/vinso";

    home.packages = with pkgs; [
      qbittorrent
      telegram-desktop
      spotify
      (discord.override {
        withVencord = true;
      })
      pavucontrol
    ];

    programs.zen-browser.enable = true;

    programs.git = {
      enable = true;
      settings = {
        user.name = "Vinso";
        user.email = "8vinso8@gmail.com";
      };
    };

    programs.kitty = {
      enable = true;
    };

    programs.fastfetch.enable = true;
  };
}
