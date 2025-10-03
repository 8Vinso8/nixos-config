{
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
    ../../modules/cosmic.nix
  ];

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

}
