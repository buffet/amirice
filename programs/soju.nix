{config, ...}: let
  port = 6697;
in {
  networking.firewall.allowedTCPPorts = [port];

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
