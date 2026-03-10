{ pkgs, lib, ... }:

let
  scripts = {
    hypr-change-layout = pkgs.callPackage ./scripts/hypr-change-layout.nix { };
    toggle-microphone = pkgs.callPackage ./scripts/toggle-microphone.nix { };
    toggle-audio = pkgs.callPackage ./scripts/toggle-audio.nix { };
    ddc-brightness = pkgs.callPackage ./scripts/ddc-brightness.nix { };
  };
in
{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = builtins.readFile ./hyprland.conf;

  home.packages = with pkgs; [
    wl-clipboard
    libnotify
    wev
    playerctl
    hyprshot
  ];

  services.hyprpolkitagent.enable = true;

  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    bind = [
      "$mainMod, L, exec, ${lib.getExe scripts.hypr-change-layout}"
      "$mainMod, XF86AudioMute, exec, ${lib.getExe scripts.toggle-microphone}"
      ", XF86AudioMute, exec, ${lib.getExe scripts.toggle-audio}"
      ", XF86MonBrightnessUp, exec, pkill ddc-brightness; ${lib.getExe scripts.ddc-brightness} up"
      ", XF86MonBrightnessDown, exec, pkill ddc-brightness; ${lib.getExe scripts.ddc-brightness} down"
    ];
  };

  # Required for env variables to be exported to hyprland.
  programs.bash.enable = true;
}
