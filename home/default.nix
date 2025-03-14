{
  pkgs,
  ...
}:

{
  home.file.".config/wall.jpg".source = ./wall.jpg;
  home.pointerCursor = {
    gtk.enable = true;
    size = 24;
    hyprcursor = {
      enable = true;
      size = 24;
    };
    x11.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
  };
  gtk = {
    enable = true;
    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };
  };
  qt = {
    enable = true;
    style.name = "adwaita-dark";
  };
  programs.starship.enable = true;
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
      };
      modules = [
        "separator"
        "os"
        "kernel"
        "memory"
        "swap"
        "disk"
        "separator"
      ];
    };
  };
  programs.git = {
    enable = true;
    userName = "Vinso";
    userEmail = "8vinso8@gmail.com";
    extraConfig = {
      url = {
        "ssh://git@github.com" = {
          insteadOf = "https://github.com";
        };
      };
    };
  };
}
