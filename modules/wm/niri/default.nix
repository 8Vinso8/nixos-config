{ pkgs, ... }:

{
  imports = [
    ../waybar
    ../scripts
    ../mako
    ../fuzzel
  ];

  programs.niri.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  home-manager.users.vinso = {
    xdg.configFile."niri/config.kdl".source = ./config.kdl;
    home.packages = with pkgs; [
      # required for file picker dialogues
      nautilus
      # polkit agent
      hyprpolkitagent
      # media control
      playerctl
      # xwayland
      xwayland-satellite
      # to check key names
      wev
    ];
  };
}
