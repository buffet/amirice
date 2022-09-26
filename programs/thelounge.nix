_: let
  port = 9000;
in {
  security.acme.acceptTerms = true;
  security.acme.certs."irc.buffet.sh".email = "niclas@countingsort.com";

  services = {
    thelounge = {
      enable = true;
      inherit port;
      public = false;

      extraConfig = {
        host = "127.0.0.1";
        reverseProxy = true;
        theme = "morning";
      };
    };

    nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts."irc.buffet.sh" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://localhost:${toString port}";
        };
      };
    };
  };
}
