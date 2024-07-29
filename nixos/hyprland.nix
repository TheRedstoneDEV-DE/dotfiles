{ config, pkgs, inputs, ... }:

{
  ### *** --- Hyprland --- *** ###
  # enable Hyprland
  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
  
  programs.waybar = {
      enable = true;
      package = inputs.waybar.packages.${pkgs.system}.waybar;
      #systemd.enable = true;
  };
  # default electron apps to Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.GTK_THEME = "Breeze";
    
  environment.systemPackages = with pkgs; [
    hyprpaper
#    waybar
    alacritty
    wofi
    dunst
    qt5ct
    qt6ct
    slurp
    grim
  ];
}
