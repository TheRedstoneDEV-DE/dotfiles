{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    surge-XT
#   drumkv1 - WAIT FOR PR
    ardour
    calf
    lsp-plugins
    distrho
  ];
}
