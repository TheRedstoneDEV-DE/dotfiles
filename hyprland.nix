{ pkgs, pkgs-unstable, ... }:

{
  ### *** --- Hyprland --- *** ###
  # enable Hyprland
  programs.hyprland = {
    package = pkgs-unstable.hyprland;
    enable = true;
    xwayland.enable = true;
  };
  programs.hyprlock = {
    enable = true;
  };
  services.hypridle.enable = true;

  # default electron apps to Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.GTK_THEME = "Breeze";
    
  environment.systemPackages = (with pkgs; [
    hyprpaper
    alacritty
    rofi
    mako
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    slurp
    grim
    waybar
    wl-clipboard
    kitty
  ]);

  # ++

  # (with pkgs-stable; [
  #   # Stable Packages fallback
  # ]);
}

