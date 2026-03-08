{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome-themes-extra
    adwaita-icon-theme
    kdePackages.breeze-icons
    adwaita-qt
    adwaita-qt6
  ];

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
    colorScheme = "dark";
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "breeze-dark";
      package = pkgs.kdePackages.breeze-icons;
    };
    font.name = "Sans";
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    qt6ctSettings = {
      Appearance = {
        style = "Adwaita-dark";
        icon_theme = "breeze-dark";
        standard_dialogs = "xdgdesktopportal";
      };
      Fonts = {
        fixed = "\"Monospace,11\"";
        general = "\"Sans Serif,11\"";
      };
    };
    qt5ctSettings = {
      Appearance = {
        style = "Adwaita-dark";
        icon_theme = "breeze-dark";
        standard_dialogs = "xdgdesktopportal";
      };
      Fonts = {
        fixed = "\"Monospace,11\"";
        general = "\"Sans Serif,11\"";
      };
    };
  };

  xdg.desktopEntries = {
    qt5ct = {
      name = "Qt5 configuration tool";
      noDisplay = true; 
    };
    qt6ct = {
      name = "Qt6 configuration tool";
      noDisplay = true;
    };
  };
}
