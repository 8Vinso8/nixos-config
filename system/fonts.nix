{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      noto-fonts
      jetbrains-mono

      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrains Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
