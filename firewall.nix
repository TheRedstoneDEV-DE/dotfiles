{ pkgs, config, ... }:
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      21118
      8193
      8012
      8080
      27040 # Steam game transfer
      51820 # Wireguard VPN client
      10001 # ROC
      10002 # ROC audio Stream
      10003 # ROC
      8423  # SSHD - Buildserver
      5201  # Iperf3
    ];
    allowedUDPPorts = [
      4464
      21118
      10001 # ROC
      10002 # ROC audio stream
      10003 # ROC
    ];
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
      { from = 27031; to = 27036; } # Steam game transfer
    ];
    trustedInterfaces = [ "enp34s0" ];
  };
}
