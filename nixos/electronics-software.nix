{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fritzing
    tio
    arduino-ide
    qucs-s
  ];
}
