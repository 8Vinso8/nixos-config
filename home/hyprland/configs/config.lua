hl.monitor({
  output   = "DP-1",
  mode     = "2560x1440@165",
  position = "0x0",
  scale    = "1",
})

hl.monitor({ output = "" }) -- Fallback rule

hl.config({
  general = {
    allow_tearing = false,
    border_size   = 2,
    gaps_in       = 5,
    gaps_out      = 0,
    layout        = "scrolling",
    col           = {
      active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
      inactive_border = "rgba(00000000)",
    },
  },
  decoration = {
    rounding = 10,
    shadow   = {
      enabled      = true,
      range        = 4,
      render_power = 3,
      color        = "rgba(26,26,26,0.933)",
    },
    blur     = {
      enabled  = true,
      size     = 3,
      passes   = 1,
      vibrancy = 0.1696,
    },
  },
  animations = {
    enabled = true,
  },
  input = {
    kb_layout    = "us,ru",
    kb_options   = "grp:alt_shift_toggle,caps:super",
    repeat_rate  = 25,
    repeat_delay = 350,
    follow_mouse = 2,
    sensitivity  = 0,
  },
  misc = {
    disable_hyprland_logo    = true,
    disable_splash_rendering = true,
    key_press_enables_dpms   = true,
    vrr                      = 3,
  },
  binds = {
    workspace_back_and_forth = true,
  },
  cursor = {
    inactive_timeout = 5,
    min_refresh_rate = 30,
    no_break_fs_vrr  = 2,
  },
  master = {
    mfact = 0.70,
    new_status = "slave",
  },
  scrolling = {
    column_width = 0.9,
  },
})
