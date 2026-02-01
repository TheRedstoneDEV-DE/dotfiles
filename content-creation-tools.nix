{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #kdenlive
    kdePackages.kdenlive
    obs-studio
    obs-studio-plugins.obs-pipewire-audio-capture
    obs-studio-plugins.obs-vaapi
  ];
}
