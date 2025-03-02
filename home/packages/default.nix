{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    htop
    vlc
    qbittorrent
    (discord.override {
      withVencord = true;
    })
    telegram-desktop
    inputs.zen-browser.packages."${system}".default
    spotify
    light 
  ];
}
