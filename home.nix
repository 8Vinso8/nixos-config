{ config, pkgs, ... }:

{
  home.username = "vinso";
  home.homeDirectory = "/home/vinso";

  home.packages = with pkgs; [
    hyprpolkitagent
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "Vinso";
      user.email = "8vinso8@gmail.com";
    };
  };

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
  };

  qt = {
    enable = true;
    style.name = "adwaita-dark";
  };

  programs.kitty = {
    enable = true;
  };
}
