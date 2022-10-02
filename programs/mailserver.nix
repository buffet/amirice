{nixos-mailserver, ...}: let
  password = "$2y$05$jux3kZMyIEoZ8Hlaav2wmeFlC0K7ZS/FY7UI3Wi.ourVfEKa.yiCm";
in {
  imports = [
    (import nixos-mailserver)
  ];

  mailserver = {
    enable = true;
    fqdn = "mx.buffet.sh";
    domains = ["buffet.sh"];

    loginAccounts = {
      "mail@buffet.sh" = {
        hashedPassword = password;
        catchAll = ["buffet.sh"];
      };
    };

    # use Let's Encrypt certs
    certificateScheme = 3;

    enableImap = true;
    enableImapSsl = true;
    enableManageSieve = true;

    virusScanning = false;
  };
}
