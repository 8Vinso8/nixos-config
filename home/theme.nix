{ pkgs, ... }:

{
  home.pointerCursor = {
    enable = true;
    name = "Adwaita";
    size = 24;
    package = pkgs.adwaita-icon-theme;
    gtk.enable = true;
    hyprcursor.enable = true;
    hyprcursor.size = 24;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    font.name = "Sans 11";
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
    qt6ctSettings = {
      Appearance = {
        style = "kvantum";
        icon_theme = "Papirus-Dark";
        standard_dialogs = "xdgdesktopportal";
      };
      Fonts = {
        fixed = "\"Monospace,11\"";
        general = "\"Sans Serif,11\"";
      };
    };
  };

  xdg.configFile."icons".source = ./icons;
}
