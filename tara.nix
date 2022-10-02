{
  pkgs,
  agenix,
  ...
}: {
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
  ];

  users.users.buffet = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = import ./keys.nix;
  };
}
