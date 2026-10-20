hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.15, 1 } } })


hl.animation({ leaf = "global", enabled = true, speed = 5, bezier = "quick" })

hl.animation({ leaf = "windowsIn",   enabled = true, speed = 1.49, bezier = "quick", style = "popin 77%" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 1,    bezier = "quick", style = "popin 100%"})
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2.5,  bezier = "quick" })

hl.animation({ leaf = "fade",        enabled = true, speed = 2.5, bezier = "quick" })
hl.animation({ leaf = "fadeOut",     enabled = true, speed = 2.5, bezier = "quick" })

hl.animation({ leaf = "workspaces",       enabled = true, speed = 2.2, bezier = "quick",        style = "slidevert" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 1.3, bezier = "almostLinear", style = "fade" })

hl.animation({ leaf = "layers",    enabled = true, speed = 2.5, bezier = "quick", style = "fade" })
hl.animation({ leaf = "layersIn",  enabled = true, speed = 2.5, bezier = "quick", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2.5, bezier = "quick", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2.5, bezier = "quick" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2.5, bezier = "quick" })
