{
  pkgs,
  inputs,
  ...
}:

{
  imports = [ 
    ../../home
    ../../home/programs/neovim
    ../../home/programs/kitty.nix
    ../../home/shells/fish
    ../../home/programs/yazi.nix
  ];

  home.username = "vinso";
  home.homeDirectory = "/home/vinso";
  home.packages = with pkgs; [
    qbittorrent
    inputs.zen-browser.packages."${system}".default
    telegram-desktop
    spotify
    (discord.override {
      withVencord = true;
    })
    vlc
    htop
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
