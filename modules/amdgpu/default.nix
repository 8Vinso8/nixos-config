{
  ...
}:
{
  imports = [
    ./memreserver.nix
  ];
  hardware = {
    amdgpu.initrd.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    memreserver.enable = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.variables = {
    VDPAU_DRIVER = "radeonsi";
  };

  programs.corectrl.gpuOverclock.ppfeaturemask = "0xffffffff";
}
