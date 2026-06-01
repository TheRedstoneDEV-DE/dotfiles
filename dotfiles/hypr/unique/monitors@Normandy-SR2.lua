hl.monitor({
  output = "DP-3",
  mode = "3440x1440@100Hz",
  position = "0x0",
  scale = "1.0",
})

hl.monitor({
  output = "HDMI-A-1",
  mode = "1920x1080@180Hz",
  position = "auto",
  scale = "1.0",
})

hl.workspace_rule({ workspace = "1", monitor = "DP-3", on_created_empty = "keepassxc"})
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1", on_created_empty = "feishin & qpwgraph"})
hl.workspace_rule({ workspace = "3", monitor = "DP-3", on_created_empty = "librewolf"})
hl.workspace_rule({ workspace = "4", monitor = "DP-3", on_created_empty = "alacritty"})

