{ security, ... }:
{
  security.pki.certificateFiles = [
    ./ssl/CA.pem
  ];
}
