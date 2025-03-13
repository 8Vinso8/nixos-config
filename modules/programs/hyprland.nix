{
  ...
}:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.dconf.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
