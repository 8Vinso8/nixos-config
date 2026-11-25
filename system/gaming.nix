{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = "1";
        PROTON_ENABLE_WAYLAND = "1";
        PROTON_FSR4_UPGRADE = "1";
      };
    };
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  programs.gamemode.enable = true;
}
