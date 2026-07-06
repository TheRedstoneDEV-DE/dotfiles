{ pkgs, lib, nixpkgs, ...}:
let
  system = "x86_64-linux";
  client = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      ({ config, lib, modulesPath, ... }: {
        imports = [
          ./client.nix
          ./specializations.nix
          ../vendors/intel/gpu/default.nix
        ];
      })
    ];
  };
  clientBuild = client.config.system.build;
in {

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "eno1";
      bind-interfaces = true;
      port = 0;
  
      dhcp-range = [ "192.168.10.50,192.168.10.200,12h" ];
      dhcp-option = [
        "option:router,192.168.10.1"
        "option:dns-server,192.168.10.1"
      ];
  
      enable-tftp = true;
      tftp-root = "/srv/tftp";
  
      dhcp-match = [
        "set:efi64,option:client-arch,7"
        "set:efi64,option:client-arch,9"
        "set:bios,option:client-arch,0"
      ];
      dhcp-boot = [
        "tag:ipxe,boot.ipxe"
        "tag:efi64,ipxe-shim.efi"
        "tag:bios,undionly.kpxe"
      ];
  
      dhcp-userclass = "set:ipxe,iPXE";
      log-dhcp = true;
    };
  };

  systemd.services.dnsmasq.wantedBy = lib.mkForce [ ];
  
  systemd.tmpfiles.rules = [ "d /srv/tftp 0755 root root -" ];
  
  environment.etc."netboot/boot.ipxe".text = ''
    #!ipxe
    menu Select Hardware Specialization
    item universal  AMD / Intel / nouveau (universal/FOSS)
    item nvidiaprod Current NVIDIA proprietary (Maxwell/Pascal+)
    item nvidia470  Legacy  NVIDIA proprietary (Kepler/early Maxwell, version 470)
    choose target && goto ''${target}
  
    :universal
    kernel bzImage init=${clientBuild.toplevel}/init ${toString client.config.boot.kernelParams} loglevel=4
    initrd initrd
    boot

    :nvidiaprod
    kernel bzImage init=${clientBuild.toplevel}/specialisation/nvidiaprod/init ${toString client.config.boot.kernelParams} loglevel=4
    initrd initrd
    boot

    :nvidia470
    kernel bzImage init=${clientBuild.toplevel}/specialisation/nvidia470/init ${toString client.config.boot.kernelParams} loglevel=4
    initrd initrd
    boot
  '';

  system.activationScripts.tftpAssets.text = ''
    mkdir -p /srv/tftp
    ln -sf ${clientBuild.kernel}/bzImage        /srv/tftp/bzImage
    ln -sf ${clientBuild.initialRamdisk}/initrd /srv/tftp/initrd
    ln -sf ${pkgs.ipxe}/ipxe.efi                /srv/tftp/ipxe.efi
    ln -sf ${pkgs.ipxe}/undionly.kpxe           /srv/tftp/undionly.kpxe
    cp -f  /etc/netboot/boot.ipxe               /srv/tftp/boot.ipxe
    cp -f /etc/netboot/boot.ipxe                /srv/tftp/autoexec.ipxe
  '';

  services.nfs.server = {
    enable = true;
    exports = ''
      /nix/store 192.168.10.0/24(ro,nohide,insecure,no_subtree_check,no_root_squash)
    '';
  };

  systemd.services.nfs-server.wantedBy = lib.mkForce [ ];

  environment.systemPackages = [
    pkgs.nbd
  ];

  networking.firewall.allowedUDPPorts = [ 67 69 4011 ];
  networking.firewall.allowedTCPPorts = [ 2049 ];
}
