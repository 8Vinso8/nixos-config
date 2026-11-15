{ ... }:

let
  browser = [ "zen-beta.desktop" ];
  fileManager = [ "yazi.desktop" ];
  videoPlayer = [ "mpv.desktop" ];
  audioPlayer = [ "org.fooyin.fooyin.desktop" ];
  torrentClient = [ "org.qbittorrent.qBittorrent.desktop" ];
in
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Папки и архивы
      "inode/directory" = fileManager;
      "application/zip" = fileManager;
      "application/x-tar" = fileManager;
      "application/x-7z-compressed" = fileManager;
      "application/x-rar" = fileManager;

      # Web & Ссылки
      "text/html" = browser;
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
      "audio/mpeg" = audioPlayer;
      "audio/flac" = audioPlayer;

      # Торренты
      "x-scheme-handler/magnet" = torrentClient;
      "application/x-bittorrent" = torrentClient;
    };
  };
}
