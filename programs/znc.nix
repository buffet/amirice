_: let
  port = 4124;
in {
  networking.firewall.allowedTCPPorts = [port];

  services.znc = {
    enable = true;
    useLegacyConfig = false;

    config = {
      LoadModule = ["webadmin"];

      Listener.l = {
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
}
