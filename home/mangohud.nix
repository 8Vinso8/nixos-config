{ lib, ... }:

{
  programs.mangohud = {
    enable = true;
    enableSessionWide = false;
  };

  # Use direct config text to preserve exact visual line ordering
  # (Home Manager's `settings` attrset sorts keys alphabetically, scrambling the HUD)
  xdg.configFile."MangoHud/MangoHud.conf".text = lib.mkForce ''
    # Position & Appearance (1440p)
    no_display
    legacy_layout=0
    position=top-left
    offset_x=16
    offset_y=16
    round_corners=8
    font_size=20
    background_alpha=0.65

    # Catppuccin Mocha Palette
    background_color=11111b
    text_color=cdd6f4
    gpu_color=a6e3a1
    cpu_color=89b4fa
    vram_color=a6e3a1
    ram_color=89b4fa
    engine_color=cba6f7
    frametime_color=cba6f7
    fps_color=a6e3a1,f9e2af,f38ba8
    fps_value=120,60

    # 1. GPU
    gpu_stats
    gpu_temp
    gpu_core_clock
    vram

    # 2. CPU
    cpu_stats
    cpu_temp
    cpu_mhz
    ram

    # 3. FPS & Frametime
    fps
    frametime
    frame_timing=1

    # Keybinds
    toggle_hud=Shift_R+F12
    toggle_hud_position=Shift_R+F11
    toggle_preset=Shift_R+F10
  '';
}
