{ pkgs, lib, config, ... }:
{
  boot = {
    initrd.kernelModules = [
      "kvm-amd"
      "vfio-pci"
      "vfio"
      "vfio_iommu_type1"
    ];
    kernelModules =  [
      "kvm-amd"
      "vfio-pci"
      "vfio"
      "vfio_iommu_type1"
    ];
    kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
      "video=efifb:off"
      "vfio-pci.ids=1002:73df,1002:ab28"
    ];
    extraModprobeConfig = "options vfio-pci ids=1002:73df,1002:ab28";
    blacklistedKernelModules = [ "amdgpu" "radeon" ];
  };

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 robert qemu-libvirtd -"
  ];

  services.udev.extraRules = ''
      SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
   '';

  environment.systemPackages = with pkgs; [
    looking-glass-client
  ];
}
