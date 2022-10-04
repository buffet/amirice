{pkgs, ...}: let
  port = 4123;
in {
  networking.firewall.allowedTCPPorts = [port];

  systemd.services.weechat = {
    after = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      User = "buffet";
      Group = "users";
    };

    script = "exec ${pkgs.screen}/bin/screen -Dm -S weechat ${pkgs.weechat}/bin/weechat";
  };
}
