{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    font = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
      size = 12;
    };
    settings = {
      disable_ligatures = "cursor";
      cursor_shape = "beam";
      cursor_blink_interval = 0;
      cursor_trail = 3;
      cursor_trail_decay = "0.1 0.4";
      window_padding_width = 6;
      placement_strategy = "center";
      confirm_os_window_close = 0;
      scrollback_lines = 10000;
      enable_audio_bell = false;
      detect_urls = true;
      url_style = "curly";
      notify_on_cmd_finish = "unfocused 10.0";
    };
  };

  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "kitty.desktop" ];
  };
}
