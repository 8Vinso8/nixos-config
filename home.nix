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
    ./home
    inputs.zen-browser.homeModules.beta
  ];

  home.packages = with pkgs; [
    strawberry
    qbittorrent
    (discord.override {
      withVencord = true;
    })
    goverlay
    vlc

    pcmanfm
    kdePackages.ark

    pavucontrol

    ddcutil

    hdparm

    balatro-mod-manager

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

  programs.zen-browser.enable = true;

  programs.btop.enable = true;

  services.syncthing.enable = true;

  home.stateVersion = "${stateVersion}";
}
