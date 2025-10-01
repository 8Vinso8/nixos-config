{ pkgs, secrets, hostname, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules
    ];


}
