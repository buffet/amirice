{
  config,
  pkgs,
  ...
}: let
  port = 4124;
  certdir = "/var/lib/znc/certs";
in {
  networking.firewall.allowedTCPPorts = [port];

  services.znc = {
    enable = true;
    useLegacyConfig = false;

    config = {
      LoadModule = ["webadmin"];

      SSLCertFile = "${certdir}/cert.pem";
      SSLKeyFile = "${certdir}/key.pem";

      Listener.l = {
        Host = "irc.buffet.sh";
        Port = port;
        SSL = true;
        IPv4 = true;
        IPv6 = true;
      };

      User.buffet = {
        Admin = true;
        Nick = "buffet";
        AltNick = "buffet-";
        RealName = "buffet";
        Ident = "buffet";
        QuitMsg = "byebye";
        LoadModule = ["chansaver" "controlpanel"];
        Pass = "sha256#d271536ea81296ebc9914b295c60024231a7beb4a05a1416485d42b0af3cc9ab#47DUOGLVcHKp7sJGwy:_#";
      };
    };
  };

  systemd.services.bind-znc-certs = {
    description = "mount certs for znc with different perms";
    after = ["local-fs.target"];
    wantedBy = ["znc.service"];
    serviceConfig.Type = "forking";

    preStart = ''
      ${pkgs.coreutils}/bin/mkdir -p ${certdir}
    '';

    script = ''
      ${pkgs.bindfs}/bin/bindfs -u znc -g znc -r -p 0400,u+D \
        ${config.security.acme.certs."buffet.sh".directory}    \
        ${certdir}
    '';
  };
}
