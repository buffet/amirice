{ config, pkgs, ... }:
let
  sources = import ./nix/sources.nix;
in
{
  imports = [
    <machine>
    ./ids.nix
    ./modules
    ./users.nix
  ];

  nix = {
    autoOptimiseStore = true;
    trustedUsers = [ "root" "buffet" ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    nixPath = [
      "nixpkgs=${sources.nixpkgs}"
      "nixos-config=/etc/nixos/configuration.nix"
      "nixpkgs-unstable=${sources.nixpkgs-unstable}"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };

  nixpkgs = {
    overlays = [ (import ./overlay { inherit config; }) ];
    pkgs = import sources.nixpkgs {};
  };

  environment.systemPackages = with pkgs; [
    git
    kakoune
    niv
    nixrl
  ];

  time.timeZone = "UTC";
  #i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "20.03";
}
