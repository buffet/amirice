_: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "niclas@countingsort.com";
    certs."buffet.sh" = {
      extraDomainNames = [
        "bitwarden.buffet.sh"
        "blog.buffet.sh"
        "damned.gay"
        "irc.buffet.sh"
        "mx.buffet.sh"
        "severely.gay"
        "stuff.severely.gay"
        "unix.pics"
      ];
    };
  };
}
