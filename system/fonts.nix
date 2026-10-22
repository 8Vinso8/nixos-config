{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      noto-fonts
      jetbrains-mono
      nerd-fonts.jetbrains-mono

      noto-fonts-cjk-sans
      twitter-color-emoji

      # For steam
      liberation_ttf
    ];

    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif"
          "emoji"
        ];
        sansSerif = [
          "Noto Sans"
          "emoji"
        ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "JetBrains Mono"
          "emoji"
        ];
        emoji = [ "Twitter Color Emoji" ];
      };
    };
  };
}
