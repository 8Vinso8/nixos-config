{ pkgs, lib, ... }:

let
  scripts = {
    hypr-change-layout = pkgs.callPackage ./scripts/hypr-change-layout.nix { };
    toggle-microphone = pkgs.callPackage ./scripts/toggle-microphone.nix { };
    toggle-audio = pkgs.callPackage ./scripts/toggle-audio.nix { };
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
  ];

  services.hyprpolkitagent.enable = true;

  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    bind = [
      "$mainMod, L, exec, ${lib.getExe scripts.hypr-change-layout}"
      "$mainMod, XF86AudioMute, exec, ${lib.getExe scripts.toggle-microphone}"
      ", XF86AudioMute, exec, ${lib.getExe scripts.toggle-audio}"
    ];
  };

  programs.bash.enable = true;
}
