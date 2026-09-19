{ ... }:

{
  programs.mpv = {
    enable = true;
    config = {
      vo = "gpu-next";
      hwdec = "auto";
      save-position-on-quit = true;
      keep-open = "yes";
    };
  };
}
