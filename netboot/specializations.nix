{ config, nixpkgs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  specialisation.nvidiaprod.configuration = {
    imports = [
      ./autodetect-pcie.nix
    ];
    services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.open = false;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
    hardware.nvidia.prime = {
      sync.enable = true;
      intelBusId  = "PCI:0:2:0";   # placeholder
      nvidiaBusId = "PCI:1:0:0";   # placeholder
    };
  };
  specialisation.nvidia470.configuration = {
    imports = [
      ./autodetect-pcie.nix
    ];
    services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    hardware.nvidia.prime = {
      sync.enable = true;
      intelBusId  = "PCI:0:2:0";   # placeholder
      nvidiaBusId = "PCI:1:0:0";   # placeholder
    };
  };
}
