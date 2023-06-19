_: {
  imports = [
    ./hardware-configuration.nix
    ./linode.nix
  ];

  # Don't change!
  system.stateVersion = "22.05";

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  boot = {
    loader.grub.forceInstall = true;
    loader.grub.device = "nodev";
    loader.timeout = 10;
    tmp.cleanOnBoot = true;
  };

  security.sudo.wheelNeedsPassword = false;
  services.openssh.enable = true;
  services.postgresql.enable = true;

  networking = {
    hostName = "tara";
    firewall.allowPing = true;
    usePredictableInterfaceNames = false;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = ["root" "buffet"];
    };

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
