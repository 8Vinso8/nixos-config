{
  ...
}:

{
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 13;
    };
    themeFile = "Dark_Pastel";
    settings = {
      disable_ligatures = "cursor";
      cursor_shape = "beam";
      cursor_beam_thickness = 1.5;
      cursor_blink_interval = 0;
      scrollback_lines = 10000;
      show_hyperlink_targets = "yes";
      repaint_delay = 6;
      notify_on_cmd_finish = "unfocused";
      enable_audio_bell = "no";
      remember_window_size = "no";
      initial_window_width = "110c";
      initial_window_height = "32c";
      background_opacity = 0.8;
      hide_window_decorations = "yes";
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_title_max_length = 15;
      wayland_enable_ime = "no";
    };
  };
}
