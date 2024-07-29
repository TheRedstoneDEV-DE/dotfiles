{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    thunderbird
    protonmail-bridge
    protonmail-bridge-gui
    libreoffice-qt6-fresh
    onlyoffice-bin_latest
    element-desktop
    gimp
    inkscape
  ];
}
