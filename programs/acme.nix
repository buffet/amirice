_: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "niclas@countingsort.com";
    certs."buffet.sh" = {
      extraDomainNames = [
        "bitwarden.buffet.sh"
        "blog.buffet.sh"
        "irc.buffet.sh"
        "mx.buffet.sh"
      ];
    };
  };
}
