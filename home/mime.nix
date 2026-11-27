{ ... }:

let
  browser = [ "zen-beta.desktop" ];
  fileManager = [ "yazi.desktop" ];
  textEditor = [ "nvim.desktop" ];
  videoPlayer = [ "mpv.desktop" ];
  audioPlayer = [ "org.fooyin.fooyin.desktop" ];
  torrentClient = [ "org.qbittorrent.qBittorrent.desktop" ];
in
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Папки
      "inode/directory" = fileManager;

      # Текст и конфиги
      "text/plain" = textEditor;
      "text/markdown" = textEditor;
      "application/json" = textEditor;
      "application/x-shellscript" = textEditor;

      # Web & Ссылки
      "text/html" = browser;
      "application/xhtml+xml" = browser;
      "text/xml" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;

      # PDF и изображения
      "application/pdf" = browser;
      "image/jpeg" = browser;
      "image/png" = browser;
      "image/gif" = browser;
      "image/webp" = browser;
      "image/bmp" = browser;
      "image/svg+xml" = browser;
      "image/avif" = browser;

      # Видео и аудио
      "video/mp4" = videoPlayer;
      "video/mkv" = videoPlayer;
      "video/webm" = videoPlayer;
      "video/x-matroska" = videoPlayer;
      "video/x-msvideo" = videoPlayer;
      "video/quicktime" = videoPlayer;
      "audio/mpeg" = audioPlayer;
      "audio/flac" = audioPlayer;
      "audio/ogg" = audioPlayer;
      "audio/wav" = audioPlayer;
      "audio/aac" = audioPlayer;
      "audio/opus" = audioPlayer;

      # Торренты
      "x-scheme-handler/magnet" = torrentClient;
      "application/x-bittorrent" = torrentClient;
    };
  };
}
