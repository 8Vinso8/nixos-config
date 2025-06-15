{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  services.openssh.enable = true;
}
