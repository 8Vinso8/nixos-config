{ hostname, inputs, ... }:

{
  networking.hostName = "${hostname}";
  networking.networkmanager.enable = true;
  services.resolved.enable = true;
  networking.firewall.enable = false;

  nixpkgs.overlays = [
    (final: prev: {
      throne = inputs.nixpkgs-throne.legacyPackages.${prev.system}.throne;
    })
  ];
  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };
}
