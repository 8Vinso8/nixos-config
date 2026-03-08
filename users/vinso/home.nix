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
  ];

  programs.fastfetch.enable = true;

  programs.zen-browser.enable = true;

  home.stateVersion = "${stateVersion}";
}
