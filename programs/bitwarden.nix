{config, ...}: let
  port = 12224;
in {
  age.secrets.bitwarden.file = ../secrets/bitwarden.age;

  services = {
    vaultwarden = {
      enable = true;
      environmentFile = config.age.secrets.bitwarden.path;
      config = {
        domain = "https://bitwarden.buffet.sh/";
        signupsAllowed = false;
        rocketPort = port;
      };
    };

    nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts."bitwarden.buffet.sh" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://localhost:${toString port}";
        };
      };
    };
  };
}
