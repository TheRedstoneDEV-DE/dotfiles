{ lib, config, pkgs, modulesPath, ... }:
{
  boot.initrd.kernelModules = [ "nouveau" ];
  boot.kernelModules = [ "nouveau" ];
  boot.blacklistedKernelModules = [" nvidia" "nvidia_uvm" "nvidia_drm" "nvidia_modeset" ];
  
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      vulkan-loader
      libvdpau-va-gl
    ];
  };
}
