{pkgs, ...}: let
  port = 4124;
in {
  networking.firewall.allowedTCPPorts = [port];

  environment.systemPackages = with pkgs; [
    screen
  ];

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
