{ config, ... }:
{
  services.openssh = {
    enable = true;
    ports = [ 8423 ];
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };
}
