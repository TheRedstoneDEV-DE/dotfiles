{ pkgs, ... }:
{
  hardware.printers = {
    ensurePrinters = [
      {
        name = "HP-OfficeJet-Pro-9130e";
        deviceUri = "ipp://192.168.178.201/ipp/print";
        model = "everywhere";
      }
    ];
    ensureDefaultPrinter = "HP-OfficeJet-Pro-9130e";
  };

  services.printing = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    thunderbird
    libreoffice-qt6-fresh
    onlyoffice-desktopeditors
    element-desktop
    gimp
    inkscape
    marktext
  ];
}
