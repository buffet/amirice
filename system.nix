_: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  # Don't change!
  system.stateVersion = "20.03";

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.cleanTmpDir = true;
  security.sudo.wheelNeedsPassword = false;
  services.openssh.enable = true;
  services.postgresql.enable = true;

  networking = {
    hostName = "tara";
    firewall.allowPing = true;
  };

  nix = {
    autoOptimiseStore = true;
    trustedUsers = ["root" "buffet"];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
