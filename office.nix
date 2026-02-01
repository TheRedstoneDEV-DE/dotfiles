{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    thunderbird
    libreoffice-qt6-fresh
    onlyoffice-desktopeditors
    element-desktop
    gimp
    inkscape
    marktext
  ];
}
