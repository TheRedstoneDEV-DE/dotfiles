local hostname_file = io.open("/etc/hostname")
if hostname_file then
  local hostname = hostname_file:read("*l")
  hostname_file:close()
  require("unique.monitors@" .. hostname)
  require("unique.keyboard@" .. hostname)
  require("unique.autostart@" .. hostname)
end
------------------
-- APPLICATIONS --
------------------

Filemanager = "nemo"
Terminal = "alacritty"
Menu = "rofi -show drun"
Main_mod = "SUPER"

hl.env("HYPRCURSOR_THEME", "NixOS-Cursors")
hl.env("HYPRCURSOR_SIZE", "28")

require("shortcuts")
require("animations")
require("rules")
require("autostart")

hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "1.0",
})

hl.config({
  dwindle = {
    preserve_split = true,
  },
})
