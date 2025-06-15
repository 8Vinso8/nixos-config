{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  services.openssh.enable = true;
  console.font = "ter-c18b";
}
