{
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
    ../../modules/cosmic.nix
  ];

  services.xserver.enable = true;
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

}
