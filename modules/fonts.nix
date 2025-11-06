{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      roboto
      roboto-mono

      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Roboto" ];
        sansSerif = [ "Roboto" ];
        monospace = [ "Roboto Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
