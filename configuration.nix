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

    ./modules/wm/scripts
    ./modules/wm/waybar
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

    # Niri
    fuzzel
    mako
    xwayland-satellite
    pavucontrol
    ddcutil
    playerctl
    libnotify
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    wev
  ];

  #Niri and deps
  programs.niri.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  hardware.i2c.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  home-manager.users.vinso = {
    home.username = "vinso";
    home.homeDirectory = "/home/vinso";

    home.packages = with pkgs; [
      hyprpolkitagent
      qbittorrent
      waybar
      pcmanfm-qt
      telegram-desktop
      gimp
      spotify
      (discord.override {
        withVencord = true;
      })
    ];

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
