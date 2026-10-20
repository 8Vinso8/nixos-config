{
  stateVersion,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    ./home/hyprland
    ./home/fish.nix
    ./home/waybar
    ./home/fastfetch.nix
    ./home/git.nix
    ./home/kitty.nix
    ./home/mako.nix
    ./home/mpv.nix
    ./home/rofi
    ./home/nvim-nvf.nix
    ./home/theme.nix
    inputs.zen-browser.homeModules.beta
  ];

  home.packages = with pkgs; [
    antigravity-cli
    boxflat
    fooyin
    qbittorrent
    kdePackages.dolphin
    kdePackages.ark
    pavucontrol

    inputs.optiscaler-client.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.zen-browser.enable = true;

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
