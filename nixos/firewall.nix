{ pkgs, config, ... }:
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8193
      8080
    ];
  };
}
