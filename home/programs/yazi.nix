{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    ffmpeg # for video thumbnails
    p7zip # for archive extraction and preview
    jq # for json preview
    poppler # for pdf preview
    fd # for file searching
    ripgrep # for file contents searching
    fzf # for quick file subtree navigation
    zoxide # for historical directories navigation
    imagemagick # for SVG, Font, HEIC, and JPEG XL preview
    wl-clipboard
  ];
  programs.yazi = {
    enable = true;
    settings = {
      manager = {
        show_hidden = true;
      };
    };
  };
}
