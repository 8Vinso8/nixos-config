{
  stateVersion,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./home/hyprland
    ./home/hyprpaper
    ./home/fish.nix
    ./home/waybar
    ./home/fuzzel.nix
    ./home/git.nix
    ./home/hypridle.nix
    ./home/kitty.nix
    ./home/mako.nix
    ./home/mpv.nix
    ./home/nvim-nvf.nix
    ./home/theme.nix
    inputs.zen-browser.homeModules.beta
  ];

  home.packages = with pkgs; [
    fooyin
    qbittorrent
    discord
    kdePackages.dolphin
    kdePackages.ark
    pavucontrol

    inputs.optiscaler-client.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.fastfetch.enable = true;

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };

  programs.btop.enable = true;

  services.syncthing.enable = true;

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

  home.stateVersion = "${stateVersion}";
}
