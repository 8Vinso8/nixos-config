{ config, pkgs, ... }:

let
  catppuccinGtk = pkgs.catppuccin-gtk.override {
    accents = [ "mauve" ];
    variant = "mocha";
    size = "standard";
  };
  catppuccinIcons = pkgs.catppuccin-papirus-folders.override {
    flavor = "mocha";
    accent = "mauve";
  };
  catppuccinKde = pkgs.catppuccin-kde.override {
    flavour = [ "mocha" ];
    accents = [ "mauve" ];
  };
  qtColorScheme = "${config.xdg.configHome}/qt6ct/colors/CatppuccinMochaMauve.conf";
in
{
  home.packages = [
    pkgs.kdePackages.breeze
  ];

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

  home.pointerCursor = {
    enable = true;
    name = "Adwaita";
    size = 24;
    package = pkgs.adwaita-icon-theme;
    gtk.enable = true;
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
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  xdg.configFile = {
    "gtk-4.0/assets".source =
      "${catppuccinGtk}/share/themes/catppuccin-mocha-mauve-standard/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source =
      "${catppuccinGtk}/share/themes/catppuccin-mocha-mauve-standard/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source =
      "${catppuccinGtk}/share/themes/catppuccin-mocha-mauve-standard/gtk-4.0/gtk-dark.css";

    "qt6ct/colors/CatppuccinMochaMauve.conf".text = ''
      [ColorScheme]
      active_colors=#ffcdd6f4, #ff313244, #ff45475a, #ff313244, #ff181825, #ff1e1e2e, #ffcdd6f4, #ffffffff, #ffcdd6f4, #ff1e1e2e, #ff181825, #ff11111b, #ffcba6f7, #ff11111b, #ff89b4fa, #ffcba6f7, #ff181825, #ff1e1e2e, #ff1e1e2e, #ffcdd6f4, #ff313244
      disabled_colors=#ffa6adc8, #ff313244, #ff45475a, #ff313244, #ff181825, #ff1e1e2e, #ffa6adc8, #ffffffff, #ffa6adc8, #ff1e1e2e, #ff181825, #ff11111b, #4dcba6f7, #ffa6adc8, #ff89b4fa, #ffcba6f7, #ff181825, #ff1e1e2e, #ff1e1e2e, #ffa6adc8, #ff313244
      inactive_colors=#ffcdd6f4, #ff313244, #ff45475a, #ff313244, #ff181825, #ff1e1e2e, #ffcdd6f4, #ffffffff, #ffcdd6f4, #ff1e1e2e, #ff181825, #ff11111b, #ffcba6f7, #ff11111b, #ff89b4fa, #ffcba6f7, #ff181825, #ff1e1e2e, #ff1e1e2e, #ffcdd6f4, #ff313244
    '';

    "kdeglobals".text =
      (builtins.readFile "${catppuccinKde}/share/color-schemes/CatppuccinMochaMauve.colors")
      + ''
        [General]
        TerminalApplication=kitty

        [Icons]
        Theme=Papirus-Dark
      '';

    "dolphinrc".text = ''
      [General]
      Version=202

      [KFileDialog Settings]
      Places Icons Auto-resize=false
      Places Icons Static Size=22

      [MainWindow]
      MenuBar=Disabled

      [UiSettings]
      ColorScheme=CatppuccinMochaMauve
    '';

    "icons".source = ./icons;
  };

  xdg.dataFile."color-schemes/CatppuccinMochaMauve.colors".source =
    "${catppuccinKde}/share/color-schemes/CatppuccinMochaMauve.colors";

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    qt6ctSettings = {
      Appearance = {
        style = "Breeze";
        icon_theme = "Papirus-Dark";
        standard_dialogs = "xdgdesktopportal";
        custom_palette = true;
        color_scheme_path = qtColorScheme;
      };
      Fonts = {
        fixed = "\"Monospace,11\"";
        general = "\"Sans Serif,11\"";
      };
    };
    qt5ctSettings = {
      Appearance = {
        style = "Fusion";
        icon_theme = "Papirus-Dark";
        standard_dialogs = "xdgdesktopportal";
        custom_palette = true;
        color_scheme_path = qtColorScheme;
      };
      Fonts = {
        fixed = "\"Monospace,11\"";
        general = "\"Sans Serif,11\"";
      };
    };
  };
}
