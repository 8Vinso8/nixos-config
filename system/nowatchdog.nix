{ ... }:

{
  boot.kernelParams = [ "nowatchdog" ];

  boot.blacklistedKernelModules = [ "sp5100_tco" ];
}
