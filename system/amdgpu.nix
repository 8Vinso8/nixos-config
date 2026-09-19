{ ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.lact.enable = true;
  hardware.amdgpu.initrd.enable = true;
  hardware.amdgpu.overdrive.enable = true;
}
