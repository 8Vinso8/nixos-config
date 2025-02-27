{
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

  home.username = "axe";
  home.homeDirectory = "/home/axe";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
