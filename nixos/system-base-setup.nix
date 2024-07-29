{ config, pkgs, ... }:
{
  programs.wireshark.enable = true;
  environment.systemPackages = with pkgs; [
    btop
    neovim
    vscodium
    librewolf
    vlc
    mpv
    supersonic-wayland
    qpwgraph
    carla
    rnnoise-plugin
    mattermost-desktop
    sshfs
    keepassxc
    deja-dup
    helix
    fzf
    open-stage-control
    opensnitch-ui
    git
    nvtopPackages.amd
    openvpn
    openssl
    easyrsa
    alsa-scarlett-gui
    nmap
    wl-clipboard
    cava
    pamixer
    ncpamixer
    virt-manager
    brightnessctl
  ];
}
