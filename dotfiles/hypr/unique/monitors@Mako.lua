hl.monitor({
  output = "eDP-1",
  mode = "1366x768@60Hz",
  position = "0x0",
  scale = "1.0",
})

hl.workspace_rule({ workspace = "1", on_created_empty = "keepassxc"})
hl.workspace_rule({ workspace = "2", on_created_empty = "alacritty"})
hl.workspace_rule({ workspace = "3", on_created_empty = "librewolf"})
