hl.layer_rule({
  name = "mako",
  xray = true,
  blur = true,
  no_screen_share = true,
  ignore_alpha = 0.1,
  match = { namespace = "notifications"},
})

hl.window_rule({
  name = "steam-games",
  match = { class = "steam*" },
  opaque = true,
  no_blur = true,
  float = true,
  no_anim = true,
  sync_fullscreen = true,
  immediate = true,
  no_shadow = true,
  decorate = false,
  workspace = "6"
})
