{ pkgs, stateVersion, ... }:

{
  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  time.timeZone = "Asia/Vladivostok";

  i18n.defaultLocale = "ru_RU.UTF-8";

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  programs.fish.enable = true;
  users.users.vinso = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "vinso";
    extraGroups = [
      "networkmanager"
      "wheel"
      "realtime"
    ];
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  documentation.nixos.enable = false;

  system.stateVersion = "${stateVersion}";
}
