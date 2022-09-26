{config, ...}: let
  port = 6697;
in {
  networking.firewall.allowedTCPPorts = [port];

  security.acme = {
    acceptTerms = true;
    certs."irc.buffet.sh".email = "niclas@countingsort.com";
  };

  services.soju = let
    certdir = config.security.acme.certs."irc.buffet.sh".directory;
  in {
    enable = true;
    hostName = "irc.buffet.sh";
    listen = [":${toString port}"];
    tlsCertificate = "${certdir}/cert.pem";
    tlsCertificateKey = "${certdir}/key.pem";
  };
}
