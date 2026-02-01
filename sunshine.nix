{ pkgs, ... }:
{
  # open ports on firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 
      47984 
      47989 
      47990 
      48010 
    ];
    allowedUDPPortRanges = [
      { from = 47998; to = 48000; }
      { from = 8000; to = 8010; }
    ];
  };

  # actually install sunshine
  environment.systemPackages = with pkgs; [
    sunshine
  ];
  
  # enanle the sunshine service
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
  };
  

  # -- Fix some stuff --
  #security.wrappers.sunshine = {
  #  owner = "root";
  #  group = "root";
  #  capabilities = "cap_sys_admin";
  #  source = "${pkgs.sunshine}/bin/sunshine";
  #};

  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;   
}
