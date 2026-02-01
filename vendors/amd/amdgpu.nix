{ config, pkgs, modulesPath, ... }:
{
  # amdgpu kernel modules
  boot.initrd.kernelModules = [ "amdgpu" ];
  
  # use amdgpu for older GPUs
  boot.kernelParams = [ 
    "radeon.si_support=0"
    "radeon.cik_support=0" 
    "amdgpu.si_support=1"
    "amdgpu.cik_support=1" 
  ];

  # AMD HIP runtime workaround
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -    -    ${pkgs.rocmPackages.clr}"
  ];
  
  # Mesa RADV  Vulkan
  hardware.graphics.enable = true;                # already enabled by default
  hardware.graphics.enable32Bit = true;       # For 32-Bit applications
  
  # Packages
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd	# OpenCL
    libva-vdpau-driver			# vaapi
    libvdpau-va-gl
    vulkan-loader		# Used for Nomic Vulkan
    # amdvlk			
    libvdpau-va-gl		# vaapi
    btop-rocm
  ];
  
  # AMDVLK for 32-Bit applications
  #hardware.graphics.extraPackages32 = with pkgs; [
  #  driversi686Linux.amdvlk
  #];
}
