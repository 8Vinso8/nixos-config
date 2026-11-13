{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    rocmOverrideGfx = "12.0.0";
    loadModels = [
      "mimo-v2.6:9b"
    ];
    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "5m";
      OLLAMA_CONTEXT_LENGTH = "65536";
    };
  };
}
