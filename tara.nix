{
  pkgs,
  agenix,
  ...
}: let
  password = "$6$FHwMlUwmRdAsPqS4$4XND0L0EEVf2Mhc/tvo6y3ZLIrMTOlsIZrG3w69EeXvtVZhdeNyoDOkPNIe.GBB8.PrchuUKDacqbvcvyuPkt0";
in {
  imports = [
    agenix.nixosModule
    ./programs
    ./system.nix
  ];

  networking.firewall.allowedTCPPorts = [80 443];
  age.identityPaths = ["/home/buffet/.ssh/id_agenix"];

  environment.systemPackages = with pkgs; [
    git
    htop
    neovim
    tree
    wget
  ];

  users.users.buffet = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    uid = 1000;
    openssh.authorizedKeys.keys = import ./keys.nix;
  };

  users.users.root.hashedPassword = password;
}
