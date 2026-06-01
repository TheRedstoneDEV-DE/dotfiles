{ pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages = (with pkgs; [
    heroic
    moonlight-qt
    xonotic
#    idtech4
#    xboxdrv
    prismlauncher
    lutris
    protontricks
#     gamescope-patched-input
    mangohud
  ])

  ++

  (with pkgs-unstable; [
    # nexusmods-app - broken
  ]);

  programs.steam = {
    enable = true;
  };
}
