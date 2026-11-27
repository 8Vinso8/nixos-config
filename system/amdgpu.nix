{ ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.amdgpu.initrd.enable = true;
  hardware.amdgpu.overdrive.enable = true;

  services.lact.enable = true;

  chaotic.mesa-git.enable = true;

  environment.sessionVariables = {
    MESA_SHADER_CACHE_MAX_SIZE = "12G";
  };
}
