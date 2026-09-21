{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      noto-fonts
      jetbrains-mono

      noto-fonts-cjk-sans
      twitter-color-emoji
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
          "JetBrains Mono"
          "emoji"
        ];
        emoji = [ "Twitter Color Emoji" ];
      };
    };
  };
}
