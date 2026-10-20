{ ... }:

{
  programs.mpv = {
    enable = true;
    config = {
      keep-open = "yes";
      slang = "en";
      alang = "en";
      ytdl-format = "bestvideo[height<=?1440]+bestaudio/best";
      ytdl-raw-options = "cookies-from-browser=firefox:~/.config/zen,mark-watched=";
      osd-bar = "no";
      border = "no";
      vo = "gpu-next";
      gpu-context = "wayland";
      hwdec = "auto-safe";
      save-position-on-quit = true;
    };
  };
}
