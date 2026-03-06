{
  networking.networkmanager = {
    enable = true;
    dns = "none";
  };

  networking.resolvconf.enable = false;
  environment.etc."resolv.conf".text = ''
    nameserver 201:f7cc:b88f:711a:8a82:70de:3f27:9a3b
  '';


  networking.firewall.allowedTCPPorts = [ 9001 ];
  services.yggdrasil = {
    enable = true;

    settings = {
      Listen = [
      ];

      Peers = [ 
        "tls://152.53.101.158:3333" 
      ];

      MulticastInterfaces = [
        {
          Regex = ".*";    
          Beacon = true;
          Listen = true;
          Port = 9001;
          Password = "";
        }
      ];
    };
    openMulticastPort = true;
    persistentKeys = true;
  };
}
