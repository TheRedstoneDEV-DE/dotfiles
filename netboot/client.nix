{pkgs, ...}:

let 
  fhs-run = pkgs.callPackage ./shell-fhs.nix { };
in
{ 
  boot.uki.name = "netboot-client";
  boot.initrd.availableKernelModules = [
    "e1000e" "igb" "r8169"
    "nfs" "nfsv3" "nfsv4" "overlay" "amdgpu"
  ];

  boot.loader.grub.enable = false;
  boot.initrd.supportedFilesystems = [ "nfs" "nfs4" "overlay" ];
  boot.initrd.systemd.emergencyAccess = true;

  boot.initrd.systemd.initrdBin = [ pkgs.nfs-utils ];

  boot.initrd.systemd.storePaths = [
    "${pkgs.nfs-utils}/bin/mount.nfs"
    "${pkgs.nfs-utils}/bin/mount.nfs4"
  ];
  
  boot.initrd.network.enable = true;
  boot.initrd.network.flushBeforeStage2 = false;
  
  networking.usePredictableInterfaceNames = false;
  boot.kernelParams = [ "ip=:::::eth0:dhcp" "radeon.si_support=0" "radeon.cik_support=0" "amdgpu.si_support=1" "amdgpu.cik_support=1" ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.extraPackages = with pkgs; [
    libva-vdpau-driver
    libvdpau-va-gl
    vulkan-loader
    libvdpau-va-gl
    libva
    libva-utils
  ];

  services.displayManager = {
    defaultSession = "none+openbox";
    autoLogin = {
      enable = true;
      user = "net";
    };
  };

  services.xserver.videoDrivers = [ "modesetting" "amdgpu" ];

  environment.systemPackages = with pkgs; [
    tint2 feh st pcmanfm btop
    dracula-icon-theme
    gnome-themes-extra
    rofi
    fhs-run
    pavucontrol
    nbd
    dialog
    pciutils
    xonotic
    steam-run-free
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.etc."xdg/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-icon-theme-name=Dracula
    gtk-theme-name=Adwaita
    gtk-application-prefer-dark-theme=1
  '';

  environment.etc."xdg/gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-icon-theme-name=Dracula
    gtk-theme-name=Adwaita
    gtk-application-prefer-dark-theme=1
  '';

  environment.etc."xdg/openbox/autostart".text = ''
    feh --bg-fill ${./wallpaper.png} &
    tint2 &
  '';

  environment.etc."xdg/openbox/menu.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <openbox_menu xmlns="http://openbox.org/3.4/menu">
      <menu id="root-menu" label="Openbox 3">
        <item label="Terminal"><action name="Execute"><command>st</command></action></item>
        <item label="Launcher"><action name="Execute"><command>rofi -show drun</command></action></item>
        <item label="Files"><action name="Execute"><command>pcmanfm</command></action></item>
        <item label="Volume"><action name="Execute"><command>pavucontrol</command></action></item>
        <separator/>
        <item label="Reconfigure"><action name="Reconfigure"/></item>
        <item label="Exit"><action name="Exit"/></item>
      </menu>
    </openbox_menu>
  '';
  
  environment.etc = {
    "xdg/openbox/rc.xml".source = ./rc.xml;
  };

  services.xserver = {
    enable = true;
    windowManager.openbox.enable = true;
    displayManager.lightdm.enable = true;
    xkb.layout = "de";
  };

  # --- store-over-NFS layering ------------------------------
  fileSystems."/nix/.ro-store" = {
    device = "192.168.10.1:/nix/store";
    fsType = "nfs4";
    options = [ "ro" "nfsvers=4.2" "nolock" "x-initrd.mount" ];
    neededForBoot = true;
  };
  fileSystems."/nix/.rw-store" = {
    fsType = "tmpfs";
    options = [ "mode=0755" "size=4G" ];
    neededForBoot = true;
  };
  fileSystems."/nix/store" = {
    device = "overlay";
    fsType = "overlay";
    options = [
      "lowerdir=/sysroot/nix/.ro-store"
      "upperdir=/sysroot/nix/.rw-store/store"
      "workdir=/sysroot/nix/.rw-store/work"
    ];
    depends = [
      "/nix/.ro-store"
      "/nix/.rw-store/store"
      "/nix/.rw-store/work"
    ];
    neededForBoot = true;
  };

  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "mode=0755" "size=2G" ];
  };
  
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };
  
  users.users.root.password = "netboot";
  users.users.root.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkskFx53+ffeaXl9JC11W/nn0Zk/RnGLIKrq5HUjh8M robert@Nomad"];
  users.users.net = {
    isNormalUser = true;
    description = "Netboot";
    extraGroups = [ "networkmanager" "wheel" "audio" "docker" "plugdev" "input" "uinput" "video" "render" ];
    password = "netboot";
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkskFx53+ffeaXl9JC11W/nn0Zk/RnGLIKrq5HUjh8M robert@Nomad"];
  };

  networking.hostName = "netboot-client";
  networking.firewall.enable = false;
}
