_: {
  networking.firewall.allowedTCPPorts = [80 443];

  security.acme = {
    acceptTerms = true;
    certs."buffet.sh".email = "niclas@countingsort.com";
  };

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."buffet.sh" = {
      enableACME = true;
      forceSSL = true;
      # TODO: website source
      root = sources.website;
    };
  };
}
