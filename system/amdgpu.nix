{ ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.amdgpu.initrd.enable = true;

  chaotic.mesa-git.enable = true;
}
