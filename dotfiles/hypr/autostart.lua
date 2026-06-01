local autostart_apps = {
  "waybar",
  "opensnitch-ui",
  "hyprpaper",
  "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
  "systemctl --user start hypridle",
  "mako",
  "/run/current-system/sw/libexec/polkit-kde-authentication-agent-1"
}

hl.on("hyprland.start", function ()
  for _,command in pairs(autostart_apps) do
    hl.exec_cmd(command)
  end
end)
