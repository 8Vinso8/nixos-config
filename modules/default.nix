{
  inputs,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    git
    wget
  ];

  security.sudo.wheelNeedsPassword = false;

  boot.loader.efi.canTouchEfiVariables = true;
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  programs.steam = {
    package = pkgs.steam.override {
      extraPkgs = pkgs: [ ];
    };
    protontricks.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      PermitRootLogin = "no";
    };
  };

  zramSwap.enable = true;

  networking.networkmanager.enable = true;
  services.resolved.enable = true;

  console = {
    packages = [ pkgs.terminus_font ];
    font = "ter-c32b";
    useXkbConfig = true;
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
}
