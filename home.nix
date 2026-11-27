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
    ./home/fastfetch.nix
    ./home/git.nix
    ./home/kitty.nix
    ./home/mpv.nix
    ./home/quickshell
    ./home/nvim
    ./home/theme.nix
    ./home/btop
    ./home/mangohud.nix
    ./home/zen.nix
    ./home/yazi
    ./home/mime.nix
  ];

  home.packages = with pkgs; [
    antigravity-cli
    opencode
    boxflat
    ed-odyssey-materials-helper
    edmarketconnector
    fooyin
    qbittorrent
    pavucontrol
    telegram-desktop
  ];

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
