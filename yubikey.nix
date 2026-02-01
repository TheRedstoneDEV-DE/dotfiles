{pkgs, ...}:
{
  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;
  environment.systemPackages = [ 
    pkgs.yubioath-flutter
    pkgs.yubikey-manager
  ];
}
