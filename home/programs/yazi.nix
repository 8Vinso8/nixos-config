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
        ratio = [
          1
          4
          3
        ];
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "size";
        show_hidden = true;
        show_symlink = true;
      };
      preview = {
        wrap = "yes";
        tab_size = 2;
        image_filter = "lanczos3";
      };
    };
  };
}
