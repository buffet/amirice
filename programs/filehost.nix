_: {
  networking.firewall.allowedTCPPorts = [80 443];

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."stuff.severely.gay" = {
      enableACME = true;
      forceSSL = true;
      root = "/var/lib/stuff";
    };
  };
}
