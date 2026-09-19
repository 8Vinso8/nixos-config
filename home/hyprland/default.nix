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

  home.packages = with pkgs; [
    wl-clipboard
    libnotify
    wev
    playerctl
    hyprshot
  ];

  services.hyprpolkitagent.enable = true;

  wayland.windowManager.hyprland.extraConfig = ''
    hl.bind("SUPER + L", hl.dsp.exec_cmd("${lib.getExe scripts.hypr-change-layout}"))
    hl.bind("SUPER + XF86AudioMute", hl.dsp.exec_cmd("${lib.getExe scripts.toggle-microphone}"))
    hl.bind("XF86AudioMute", hl.dsp.exec_cmd("${lib.getExe scripts.toggle-audio}"))
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("pkill ddc-brightness; ${lib.getExe scripts.ddc-brightness} up"))
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("pkill ddc-brightness; ${lib.getExe scripts.ddc-brightness} down"))
  '';

  # Required for env variables to be exported to hyprland.
  programs.bash.enable = true;
}
