_: {
  networking.firewall.allowedTCPPorts = [80 443];

  security.acme = {
    acceptTerms = true;
    certs."blog.buffet.sh".email = "niclas@countingsort.com";
  };

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."blog.buffet.sh" = {
      enableACME = true;
      forceSSL = true;
      # TODO: blog source
      root = import sources.blog {};
    };
  };
}
