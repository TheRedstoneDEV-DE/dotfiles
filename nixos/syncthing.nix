{ config, ... }:
{
  services = {
    syncthing = {
      enable = true;
      user = "robert";
      dataDir = "/home/robert";
      configDir = "/home/robert/.config/syncthing";
      settings.gui = {
        user = "robert";
        password = "S67_1648";
      };
      settings = {
        devices = {
          "schlingel" = { id = "4N7V7YI-6ISKWPY-4FEFFUY-GMLJH6D-CDJPZJQ-GFJVT6Z-AUMCTOU-VFUCBQX"; };
        };
        folders = {
          "Keys" = {
            id = "hqk2s-szfuv";
            path = "/home/robert/keys/";
            devices = [ "schlingel" ];
          };
          "mobile-devel" = {
            id = "9edk6-4tt4g";
            path = "/home/robert/Documents/Dev-Projects/";
            devices = [ "schlingel" ];
          };
        };
      };
    };
  };
  networking.firewall = {
    allowedTCPPorts = [
      8384
      22000
    ];
    allowedUDPPorts = [
      22000
      21027
    ];
  };
}
