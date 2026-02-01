{ ... }:
{
  services.openssh = {
    enable = true;
    ports = [ 8423 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
