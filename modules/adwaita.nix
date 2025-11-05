{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.custom.adwaitaTheme;
in
{
  options = {
    custom.adwaitaTheme = {
      enable = mkEnableOption "adwaitaTheme";
    };
  };

  config = mkIf cfg.enable {
    home-manmager.users.vinso = {
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
    };
  };
}
