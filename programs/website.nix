{website, ...}: {
  networking.firewall.allowedTCPPorts = [80 443];

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."buffet.sh" = {
      enableACME = true;
      forceSSL = true;
      root = "${website}";
    };

    virtualHosts."unix.pics" = {
      enableACME = true;
      forceSSL = true;
      root = "/var/lib/stuff/unix.pics";
    };
  };
}
