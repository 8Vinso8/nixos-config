{
  pkgs,
  hostname,
  secrets,
  ...
}:

{
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  services.resolved.enable = true;
  networking.firewall.enable = false;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
    timeout = 5;
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      roboto
      roboto-mono
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Roboto" ];
        sansSerif = [ "Roboto" ];
        monospace = [ "Roboto Mono" ];
      };
    };
  };

  programs.fish.enable = true;

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

  security.sudo.wheelNeedsPassword = false;
  users.users.vinso = {
    isNormalUser = true;
    description = "vinso";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.compositor = "kwin";
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.sing-box = {
    enable = true;
    settings = secrets.singBoxConfig;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.05";
}
