{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  virtualisation.libvirtd.enable = true;

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    useDHCP = false;
    interfaces = {
      enp0s25.useDHCP = true;
      wlp3s0.useDHCP = true;
    };
    hostName = "fanya";
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" ];

    firewall.allowedTCPPorts = [
      24800 # Barrier
    ];
  };

  nix = {
    # distributedBuilds = true;

    buildMachines = [
      {
        hostName = "buffet.sh";
        system = "x86_64-linux";
        sshUser = "buffet";
        sshKey = "/home/buffet/.ssh/id_build";
      }
    ];

    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

  hardware.bluetooth.enable = true;

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services = {
    tlp.enable = true;
    upower.enable = true;

    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenberg
        hplip
      ];
    };

    borgbackup = let
      repo = import ../../secrets/borg.nix;
    in
      {
        jobs.backup = {
          paths = [ "/etc" "/home" "/root" "/var" ];
          repo = "${repo.host}:fanya";
          encryption.mode = "repokey";
          encryption.passphrase = repo.passphrase;
          startAt = "daily";
          environment.BORG_RSH = "ssh -i /home/buffet/.ssh/id_borg";
          extraArgs = "--remote-path borg1";
          prune.keep = {
            within = "1d";
            daily = 7;
            weekly = 4;
            monthly = -1;
          };
        };
      };
  };

  systemd.coredump.enable = true;

  systemd.timers.borgbackup-job-backup.timerConfig.Persistent = true;

  systemd.services = {
    borgbackup-job-backup = {
      after = [ "ensure-online.service" ];
      requires = [ "ensure-online.service" ];
    };

    ensure-online = {
      description = "waiting for Network";
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.networkmanager}/bin/nm-online -q --timeout=300";
        Type = "oneshot";
      };
    };
  };

  buffet = {
    desktop = {
      enable = true;
      colors = import ../../modules/desktop/colors/solarized-light.nix;
      session = "xmonad";
    };

    programs = {
      bash.enable = true;
      direnv.enable = true;
      git.enable = true;
      vim.enable = true;

      extraPackages = with pkgs; [
        acpi
        barrier
        cloc
        gdb
        gitAndTools.gitflow # tools/magit
        github-cli
        htop
        plover_with_plugins
        ripgrep
        texlive.combined.scheme-full
        tree
        ultralist
        wget
      ];
    };

    services.foundry-vtt.enable = true;
  };
}
