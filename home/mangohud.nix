{ ... }:

{
  programs.mangohud = {
    enable = true;
    enableSessionWide = false;
    settings = {
      # Performance & Metrics
      legacy_layout = 0;
      gpu_stats = true;
      gpu_temp = true;
      gpu_core_clock = true;
      vram = true;

      cpu_stats = true;
      cpu_temp = true;
      cpu_mhz = true;
      ram = true;

      fps = true;
      frametime = true;
      frame_timing = 1;

      # Position & Style (1440p)
      position = "top-left";
      offset_x = 16;
      offset_y = 16;
      round_corners = 8;
      font_size = 20;
      background_alpha = "0.65";

      # Catppuccin Mocha Palette
      background_color = "11111b";
      text_color = "cdd6f4";
      gpu_color = "a6e3a1";
      cpu_color = "89b4fa";
      vram_color = "a6e3a1";
      ram_color = "89b4fa";
      engine_color = "cba6f7";
      frametime_color = "cba6f7";
      fps_color = "a6e3a1,f9e2af,f38ba8";
      fps_value = "120,60";

      # Keybinds
      toggle_hud = "Shift_R+F12";
      toggle_hud_position = "Shift_R+F11";
      toggle_preset = "Shift_R+F10";
    };
  };
}
