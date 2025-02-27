{
  inputs,
  pkgs,
  ...
}:

{
  home.packages =  with pkgs; [
    qbittorrent
    vlc
    inputs.zen-browser.packages."${system}".default
    libreoffice-qt6-fresh
  ];
}
