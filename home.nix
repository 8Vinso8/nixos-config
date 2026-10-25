{
  stateVersion,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./home/hyprland
    ./home/fish.nix
    # ./home/waybar
    ./home/fastfetch.nix
    ./home/git.nix
    ./home/kitty.nix
    ./home/mako.nix
    ./home/mpv.nix
    ./home/rofi
    ./home/nvim
    ./home/theme.nix
    ./home/btop
    ./home/mangohud.nix
    inputs.zen-browser.homeModules.beta
  ];

  home.packages = with pkgs; [
    inputs.ags-bar.packages.${pkgs.stdenv.hostPlatform.system}.default
    antigravity-cli
    opencode
    boxflat
    fooyin
    qbittorrent
    kdePackages.dolphin
    kdePackages.ark
    pavucontrol
  ];

  programs.zen-browser.enable = true;

  services.syncthing.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "org.kde.dolphin.desktop" ];
    };
  };

  xdg.userDirs = {
    enable = true;
    desktop = "Desktop";
    documents = "Documents";
    download = "Downloads";
    music = "Music";
    pictures = "Pictures";
    projects = "Projects";
    publicShare = "Public";
    templates = "Templates";
    videos = "Videos";
  };

  home.username = "vinso";
  home.homeDirectory = "/home/vinso";

  home.stateVersion = stateVersion;
}
