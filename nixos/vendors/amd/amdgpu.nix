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
  #hardware.opengl.driSupport = true;            # already enabled by default
  #hardware.opengl.driSupport32Bit = true;       # For 32-Bit applications
  
  # Packages
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd	# OpenCL
    vaapiVdpau			# vaapi
    # amdvlk			
    libvdpau-va-gl		# vaapi
  ];

  # AMDVLK for 32-Bit applications
  #hardware.opengl.extraPackages32 = with pkgs; [
  #  driversi686Linux.amdvlk
  #];
}
