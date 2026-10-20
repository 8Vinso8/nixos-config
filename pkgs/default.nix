final: prev: {
  ddc-brightness = final.callPackage ./scripts/ddc-brightness.nix { };
  toggle-audio = final.callPackage ./scripts/toggle-audio.nix { };
  toggle-microphone = final.callPackage ./scripts/toggle-microphone.nix { };
  sinkchange = final.callPackage ./scripts/sinkchange.nix { };
  rofi-powermenu = final.callPackage ./scripts/rofi-powermenu.nix { };
  rofi-clipboard = final.callPackage ./scripts/rofi-clipboard.nix { };
}
