{ config, lib, pkgs, ... }:
let
  cfg = config.buffet.services.foundry-vtt;
in
  with lib; {
    options = {
      buffet.services.foundry-vtt = {
        enable = mkEnableOption "foundry-vtt";

        port = mkOption {
          type = types.int;
          default = 30000;
          example = "30000";
          description = ''
            Port to use for foundry-vtt.
          '';
        };
      };
    };

    config = mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = [ cfg.port ];
      systemd.services.foundry-vtt = {
        enable = true;
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          DynamicUser = true;
          StateDirectory = "foundry-vtt";
        };
        script =
          "${pkgs.nodejs}/bin/node ${pkgs.foundry-vtt-headless}/resources/app/main.js --dataPath=/var/lib/foundry-vtt";
      };
    };
  }
