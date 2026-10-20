{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    plugins = with pkgs; [
      rofi-emoji
    ];
  };

  home.packages = with pkgs; [ wtype ];

  xdg.configFile."rofi/config.rasi".source = ./config.rasi;
  xdg.configFile."rofi/clipboard.rasi".source = ./clipboard.rasi;
}
