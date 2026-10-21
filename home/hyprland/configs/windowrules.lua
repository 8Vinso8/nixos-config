
hl.window_rule({
  name           = "suppress-maximize-events",
  match          = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  name     = "fix-xwayland-drags",
  match    = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },
  no_focus = true,
})

hl.layer_rule({
  match = { namespace = "notifications" },
  animation = "slide bottom",
})

hl.window_rule({
  name = "scrolling-full-width",
  match = {
    class = "^zen$",
  },
  scrolling_width = 1.0,
})

hl.window_rule({
  name = "picture-in-picture",
  match = {
    title = "^(Picture-in-Picture|Картинка в картинке)$",
  },
  float = true,
  pin = true,
  keep_aspect_ratio = true,
  no_initial_focus = true,
  size = { "monitor_w*0.25", "monitor_h*0.25" },
  move = { "monitor_w-window_w-20", "monitor_h-window_h-20" },
})

hl.window_rule({
  name = "floating-dialogs",
  match = {
    class = "^(pavucontrol|org\\.pulseaudio\\.pavucontrol|qt6ct|nwg-look|kvantummanager)$",
  },
  float = true,
  center = true,
  size = { "monitor_w * 0.45", "monitor_h * 0.55" },
})

hl.window_rule({
  name = "steam-dialogs",
  match = {
    class = "^steam$",
    title = "^(Friends List|Settings|Список друзей|Настройки)$",
  },
  float = true,
})

hl.window_rule({
  name = "steam-updater",
  match = {
    class = "^$",
    title = "^(Steam.*)$",
    xwayland = true,
  },
  workspace = "special:silent silent",
  no_initial_focus = true,
  no_anim = true,
})


hl.workspace_rule({
  workspace = "1",
  default = true,
  persistent = true,
  layout = "scrolling"
})

hl.window_rule({
  name = "mpv",
  match = {
    class = "^mpv$",
  },
  idle_inhibit = "focus",
  workspace = "2 silent",
  fullscreen = true,
  no_vrr = true,
})

local launcher_games = {
  ["244210"] = "^Assetto Corsa$",     -- Assetto Corsa (Content Manager)
  ["284160"] = "^BeamNG\\.drive.*$",  -- BeamNG.drive
}

local launcher_ids = {}
for id, _ in pairs(launcher_games) do
  table.insert(launcher_ids, id)
end

hl.window_rule({
  name = "proton-game-tag-all",
  match = {
    class = "^steam_app_.*$",
  },
  tag = "+game",
})

hl.window_rule({
  name = "proton-strip-launcher-tag",
  match = {
    class = "^steam_app_(" .. table.concat(launcher_ids, "|") .. ")$",
  },
  tag = "-game",
})

for id, title_regex in pairs(launcher_games) do
  hl.window_rule({
    name = "proton-restore-game-" .. id,
    match = {
      class = "^steam_app_" .. id .. "$",
      title = title_regex,
    },
    tag = "+game",
  })
end

hl.window_rule({
  name = "fullscreen-games",
  match = {
    tag = "game",
  },
  content = "game",
  workspace = "3 silent",
  fullscreen = true,
  border_size = 0,
  rounding = 0,
  no_anim = true,
  no_blur = true,
  no_dim = true,
  no_shadow = true,
  idle_inhibit = "always",
})

-- 3058630 - Assetto Corsa EVO
-- no_vrr = true: disables Adaptive Sync to prevent VA/IPS gamma/brightness flicker on 165Hz during frametime dips / loading.
-- immediate = true: enables tearing/asynchronous page flips (requires allow_tearing = true in config.lua) to minimize input latency.
hl.window_rule({
  name = "vrr-except",
  match = {
    class = "^steam_app_3058630$",
  },
  no_vrr = true,
  immediate = true,
})
