{ pkgs, pkgs-unstable, ... }:
{
  environment.systemPackages = (with pkgs; [
    btop
    neovim
    sshfs
    borgbackup
    fzf
    ffmpeg-full
    git
    openssl
    cava
    pamixer
    ncpamixer
    brightnessctl
    pipewire.jack
    python3
    distrobox
    ncdu
    tmux
    # currently down, reenable later! - inputs.zen-browser.packages.${pkgs.system}.default
  ])
  ++
  (with pkgs-unstable; [
   # -- unstable pgks --
  ]);
}
