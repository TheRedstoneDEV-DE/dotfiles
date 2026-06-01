-- shorteners --
local dsp = hl.dsp

-- keybinds --
local application_sc = {
  ["Q"] = Terminal,
  ["R"] = Menu,
  ["E"] = Filemanager,
  ["SHIFT + L"]     = "hyprlock",
  ["SHIFT + Print"] = "grim -g \"$(slurp)\" - | wl-copy",
  ["Print"]         = "grim - | wl-copy",
  ["SHIFT + End"]   = "waybar",
  ["SHIFT + Home"]  = "bash .util/pa_web_ctl/pa_mixer.sh",
}

local wm_sc = {
  -- general management --
  ["V"] = dsp.window.float({action = "toggle"}),
  ["P"] = dsp.window.pseudo(),
  ["J"] = dsp.layout("togglesplit"),
  ["C"] = dsp.window.close(),
  ["F"] = dsp.window.fullscreen({ action = "toggle" }),
  -- the ugly mouse --
  ["mouse:272"] = dsp.window.drag(),
  ["mouse:273"] = dsp.window.resize(),
  -- I need to get out of here --
  ["SHIFT + ALT + E"] = dsp.exit(),
}

local xf86 = {
  -- audio --
  ["AudioRaiseVolume"] = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+",
  ["AudioLowerVolume"] = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-",
  ["AudioMute"]        = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
  ["AudioMicMute"]     = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",
  -- brightness --
  ["MonBrightnessUp"]  = "brightnessctl -e4 -n2 set 2%+",
  ["MonBrightnessDown"]= "brightnessctl -e4 -n2 set 2%-"
}


-- Attention! Down here will be boring logic! --

local directions = {"left", "down", "up", "right"}

for key,program in pairs(application_sc) do
  hl.bind(Main_mod .. " + " .. key, hl.dsp.exec_cmd(program))
end

for key,action in pairs(wm_sc) do
  hl.bind(Main_mod .. " + " .. key, action)
end

for key,command in pairs(xf86) do
  hl.bind("XF86" .. key, dsp.exec_cmd(command), {locked = true, repeating = true})
end

for _,dir in pairs(directions) do
  hl.bind(Main_mod .. " + " .. dir, dsp.focus({ direction = dir }))
  hl.bind(Main_mod .. " + SHIFT + " .. dir, dsp.window.move({ direction = dir }))
end

for i = 1, 10 do
  local key = i % 10
  hl.bind(Main_mod .. " + " .. key, dsp.focus({ workspace = i }))
  hl.bind(Main_mod .. " + SHIFT + " .. key, dsp.window.move({ workspace = i }))
end
