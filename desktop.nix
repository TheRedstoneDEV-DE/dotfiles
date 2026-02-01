{ pkgs, ... }:
{
  environment.systemPackages = (with pkgs;[ 
    librewolf
    vlc
    mpv
    feishin
    qpwgraph
    carla
    rnnoise-plugin
    keepassxc
    alsa-scarlett-gui
    wl-clipboard
    virt-manager
    vesktop
    bluez
    nemo

    ## -- KDE Packages -- ##
    kdePackages.okular
    kdePackages.kate
    kdePackages.ark
    kdePackages.kio-extras
    kdePackages.kio-extras-kf5
    kdePackages.breeze
    kdePackages.breeze-icons
    kdePackages.breeze-gtk
    kdePackages.polkit-kde-agent-1
  ]);

  programs.wireshark.enable = true;
  services.gvfs.enable = true;
  programs.kdeconnect.enable = true; 
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  systemd.user.services.polkit-kde-authentication-agent-1 = {
    description = "polkit-kde-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

}
