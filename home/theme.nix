{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome-themes-extra
    adwaita-icon-theme
    kdePackages.breeze-icons
    
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    kdePackages.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
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
    kvantum = {
      enable = true;
      themes = with pkgs; [
        (catppuccin-kvantum.override {
          variant = "mocha";
          accent = "mauve";
        })
      ];
      settings.General = {
        theme = "catppuccin-mocha-mauve";
      };
    };
    qt6ctSettings = {
      Appearance = {
        style = "kvantum";
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
        style = "kvantum";
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
