{ pkgs, ... }:

let
  catppuccinGtk = pkgs.catppuccin-gtk.override {
    accents = [ "mauve" ];
    variant = "mocha";
    size = "standard";
  };
  catppuccinKvantum = pkgs.catppuccin-kvantum.override {
    variant = "mocha";
    accent = "mauve";
  };
  catppuccinIcons = pkgs.catppuccin-papirus-folders.override {
    flavor = "mocha";
    accent = "mauve";
  };
in
{
  home.packages = [
    catppuccinIcons
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
    font = {
      name = "Sans";
      size = 11;
    };
    theme = {
      name = "catppuccin-mocha-mauve-standard";
      package = catppuccinGtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = catppuccinIcons;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Стили для GTK4 / Libadwaita (аналог симлинков из dotfiles/.config/gtk-4.0)
  xdg.configFile."gtk-4.0/assets".source = "${catppuccinGtk}/share/themes/catppuccin-mocha-mauve-standard/gtk-4.0/assets";
  xdg.configFile."gtk-4.0/gtk.css".source = "${catppuccinGtk}/share/themes/catppuccin-mocha-mauve-standard/gtk-4.0/gtk.css";
  xdg.configFile."gtk-4.0/gtk-dark.css".source = "${catppuccinGtk}/share/themes/catppuccin-mocha-mauve-standard/gtk-4.0/gtk-dark.css";

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
    kvantum = {
      enable = true;
      themes = [ catppuccinKvantum ];
      settings.General.theme = "catppuccin-mocha-mauve";
    };
    qt6ctSettings = {
      Appearance = {
        style = "kvantum";
        icon_theme = "Papirus-Dark";
        standard_dialogs = "xdgdesktopportal";
        custom_palette = true;
        color_scheme_path = "/home/vinso/.config/qt6ct/style-colors.conf";
      };
      Fonts = {
        fixed = "\"Monospace,11\"";
        general = "\"Sans Serif,11\"";
      };
    };
  };

  # Цветовая палитра Catppuccin Mocha для qt6ct из dotfiles
  xdg.configFile."qt6ct/style-colors.conf".text = ''
    [ColorScheme]
    active_colors=#ffcdd6f4, #ff313244, #ff45475a, #ff45475a, #ff181825, #ff181825, #ffcdd6f4, #ffffffff, #ffcdd6f4, #ff181825, #ff1e1e2e, #ff000000, #4dcba6f7, #ffcdd6f4, #ffcba6f7, #ffcbb0f7, #ff181825, #ff000000, #ff181825, #ffcdd6f4, #80cdd6f4, #ff308cc6
    disabled_colors=#ff585b70, #ff313244, #ff45475a, #ff45475a, #ff181825, #ff181825, #ff585b70, #ffffffff, #ff585b70, #ff181825, #ff1e1e2e, #ff000000, #4dcba6f7, #66cdd6f4, #ffcba6f7, #ffcbb0f7, #ff181825, #ff000000, #ff181825, #ffcdd6f4, #80cdd6f4, #ff919191
    inactive_colors=#ffcdd6f4, #ff313244, #ff45475a, #ff45475a, #ff181825, #ff181825, #ffcdd6f4, #ffffffff, #ffcdd6f4, #ff181825, #ff1e1e2e, #ff000000, #4dcba6f7, #ffcdd6f4, #ffcba6f7, #ffcbb0f7, #ff181825, #ff000000, #ff181825, #ffcdd6f4, #80cdd6f4, #ff308cc6
  '';

  # Иконки приложений (boxflat, throne)
  xdg.configFile."icons".source = ./icons;
}
