{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    rocmOverrideGfx = "12.0.0";
    loadModels = [
      "qwen3.5:9b"
    ];
    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "5m";
      OLLAMA_CONTEXT_LENGTH = "32768";
    };
  };
}
