_: let
  port = 6697;
  internal_port = 6698;
in {
  networking.firewall.allowedTCPPorts = [port];

  security.acme = {
    acceptTerms = true;
    certs."irc.buffet.sh".email = "niclas@countingsort.com";
  };

  services = {
    soju = {
      enable = true;
      hostName = "irc.buffet.sh";
      listen = [":${internal_port}"];
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
        listen = [
          {
            addr = "irc.buffet.sh";
            inherit port;
          }
        ];

        locations."/" = {
          proxyPass = "http://localhost:${toString internal_port}";
        };
      };
    };
  };
}
