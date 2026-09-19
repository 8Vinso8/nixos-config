{
  stateVersion,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "vinso";
  home.homeDirectory = "/home/vinso";

  imports = [
    ./home/hyprland
    ./home/hyprpaper
    ./home/shell
    ./home/waybar
    ./home/fuzzel.nix
    ./home/git.nix
    ./home/hypridle.nix
    ./home/kitty.nix
    ./home/mako.nix
    ./home/nvim-nvf.nix
    ./home/theme.nix
    inputs.zen-browser.homeModules.beta
  ];

  home.packages = with pkgs; [
    strawberry
    qbittorrent
    (discord.override {
      withVencord = true;
    })
    pcmanfm
    kdePackages.ark
    pavucontrol
    ddcutil
    hdparm
    mpv
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

  programs.fastfetch.enable = true;

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };

  programs.btop.enable = true;

  services.syncthing.enable = true;

  home.stateVersion = "${stateVersion}";
}
