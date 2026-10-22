hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Increase Mesa on-disk shader cache limit to 12 GB (default is 1 GB)
-- Prevents Mesa from evicting compiled shaders across multiple heavy games when Steam shader pre-caching is disabled.
hl.env("MESA_SHADER_CACHE_MAX_SIZE", "12G")
