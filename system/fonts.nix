{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      noto-fonts
      jetbrains-mono
      nerd-fonts.jetbrains-mono

      noto-fonts-cjk-sans
      noto-fonts-color-emoji

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
        emoji = [ "Noto Color Emoji" ];
      };

      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <selectfont>
            <rejectfont>
              <pattern>
                <patelt name="family">
                  <string>DejaVu Sans</string>
                </patelt>
              </pattern>
            </rejectfont>
          </selectfont>
        </fontconfig>
      '';
    };
  };
}
