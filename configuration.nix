{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
    consoleLogLevel = 0;
    initrd = {
      kernelModules = [ "amdgpu" ];
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
    plymouth = {
      enable = true;
    };
  };
  zramSwap.enable = true;

  networking.hostName = "vinsopc";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  services.resolved.enable = true;

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

  console = {
    font = "ter-c32b";
    packages = [ pkgs.terminus_font ];
    useXkbConfig = true;
  };
  
  environment.variables = {
    VDPAU_DRIVER = "radeonsi";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

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

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.xkb.layout = "us,ru";
  services.xserver.xkb.options = "grp:caps_toggle";

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.pipewire.configPackages = [
    (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-split-input.conf" (builtins.readFile ./configs/pipewire/10-split-input.conf))
  ];
  
  services.sing-box = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./_secrets/sing-box.json);
  };
  
  security.sudo.wheelNeedsPassword = false;
  users.users.vinso = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "adbusers" ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    kdePackages.sddm-kcm
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira-code
    ];
  };

  programs.corectrl = {
    enable = true;
    gpuOverclock = {
      enable = true;
      ppfeaturemask = "0xffffffff";
    };
  };

  security.polkit = {
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

  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraPkgs = pkgs: [ pkgs.kdePackages.breeze ];
    };
  };

  programs.dconf.enable = true;
  programs.fish.enable = true;
  programs.adb.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.11";
}

