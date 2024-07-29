{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    steam
    heroic
    wine
    moonlight-qt
    xonotic
    xboxdrv
  ];
}
