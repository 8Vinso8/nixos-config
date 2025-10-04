{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
    ../../modules/plasma.nix
  ];
/*
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];
*/
  zramSwap = {
    enable = true;
  };

  services.udev.extraRules = ''
  ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x1022" ATTR{device}=="0x1483" ATTR{power/wakeup}="disabled"
'';


  hardware.amdgpu.overdrive.enable = true;
  hardware.amdgpu.initrd.enable = true;
  services.lact.enable = true;

  hardware.i2c.enable = true;

  programs.steam = {
    enable = true;
    extraPackages = [ pkgs.kdePackages.breeze ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
