local mainMod = "SUPER"

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M",
  hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("hyprlauncher"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + A", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + D", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + W", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + S", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + grave", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl -p fooyin next"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl -p fooyin play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl -p fooyin previous"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("playerctl -p fooyin volume 0.05+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("playerctl -p fooyin volume 0.05-"))

hl.bind("Print", hl.dsp.exec_cmd("hyprshot --mode region --freeze --clipboard-only"))

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("toggle-audio.sh"))
hl.bind("SUPER + XF86AudioMute", hl.dsp.exec_cmd("toggle-microphone.sh"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("pkill ddc-brightness; ddc-brightness.sh up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("pkill ddc-brightness; ddc-brightness.sh down"))

hl.bind(mainMod .. " + L", function()
  local ws = hl.get_active_workspace()
  if not ws then return end

  local layout = ws.tiled_layout == "master" and "scrolling" or "master"

  hl.workspace_rule({
    workspace = tostring(ws.id),
    layout = layout,
  })
end)

local function layout_bind(bind_table)
  return function()
    local workspace = hl.get_active_special_workspace() or
        hl.get_active_workspace()

    if not workspace then
      return
    end

    local layout = workspace.tiled_layout

    if bind_table[layout] then
      hl.dispatch(bind_table[layout])
    end
  end
end

hl.bind(mainMod .. " + SHIFT + A", layout_bind({
  scrolling = hl.dsp.layout("consume_or_expel prev"),
  master = hl.dsp.layout("swapprev"),
}))
hl.bind(mainMod .. " + SHIFT + D", layout_bind({
  scrolling = hl.dsp.layout("consume_or_expel next"),
  master = hl.dsp.layout("swapnext"),
}))
