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
    inputs.zen-browser.homeModules.beta
  ];

  home.packages = with pkgs; [
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
