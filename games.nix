{ pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages = (with pkgs; [
    steam
    heroic
    wineWowPackages.stable
    moonlight-qt
    xonotic
#    idtech4
#    xboxdrv
    prismlauncher
    lutris
    protontricks
    gamescope-patched-input
    mangohud
  ])

  ++

  (with pkgs-unstable; [
    # nexusmods-app - broken
  ]);
}
