{
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

}
