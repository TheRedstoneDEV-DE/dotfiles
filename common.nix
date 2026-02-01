{ ... }:
{
  # SSH-Agent
  programs.ssh.startAgent = true;
  environment.sessionVariables.SSH_AUTH_SOCK = "/run/user/1000/ssh-agent";
  
  users.users.robert.extraGroups = [ "dialout" ];

  # QT theming for Hyprland or other WM  
  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";
  
  # disable coredumps
  systemd.coredump.enable = false;
}
