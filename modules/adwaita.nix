{
  pkgs,
  ...
}:

{
  home-manager.users.vinso = {
    home.pointerCursor = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      gtk.enable = true;
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
      platformTheme.name = "gtk3";
      style.name = "adwaita-dark";
    };
  };
}
