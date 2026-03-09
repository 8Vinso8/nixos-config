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
    ../../home
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
  ];

  programs.fastfetch.enable = true;

  programs.zen-browser.enable = true;

  services.syncthing.enable = true;

  programs.btop.enable = true;

  home.stateVersion = "${stateVersion}";
}
