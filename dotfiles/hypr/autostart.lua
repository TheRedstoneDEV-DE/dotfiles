local autostart_apps = {
  "waybar",
  "opensnitch-ui",
  "hyprpaper",
  "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
  "systemctl --user start hypridle",
  "mako",
  "systemctl --user start plasma-polkit-agent",
  "systemctl --user start xdg-desktop-portal-hyprland"
}

hl.on("hyprland.start", function ()
  for _,command in pairs(autostart_apps) do
    hl.exec_cmd(command)
  end
end)
