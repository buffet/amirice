{ config, lib, ... }:
let
  cfg = config.buffet.services.minecraft-server;
  sources = import ../../nix/sources.nix;
  nixpkgs-unstable = import sources.nixpkgs-unstable {};
in
  with lib; {
    options = {
      buffet.services.minecraft-server = {
        enable = mkEnableOption "minecraft server";
      };
    };

    config = mkIf cfg.enable {
      services.minecraft-server = {
        enable = true;
        eula = true;
        openFirewall = true;
        package = nixpkgs-unstable.papermc;
        jvmOpts = "-Xmx1500M -Xms1500M";
      };
    };
  }
