{ pkgs, ... }:
{
  environment.systemPackages = (with pkgs; [
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
    wofi
    alacritty
    swayidle
    swaylock
    waybar
    libsForQt5.qt5ct
    qt6Packages.qt6ct
  ]);

#  ++

 # (with pkgs-stable; [
 #   # Stable fallback
 # ]);

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      #xdg-desktop-portal-gtk
    ];
    config = {common = {default = "wlr";};};
    wlr.enable = true;
    wlr.settings.screencast = {
      output_name = "DP-3";
      chooser_type = "simple";
      chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
    };
  };
  
  # default electron apps to Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.GTK_THEME = "Breeze";

  # enable sway window manager
  programs.sway = {
    enable = true;
    #wrapperFeatures.gtk = true;
  };
}
