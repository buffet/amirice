{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    website = {
      url = "github:buffet/website";
      flake = false;
    };
  };

  outputs = {nixpkgs, ...} @ args: {
    nixosConfigurations.ami = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = args;
      modules = [./ami.nix];
    };
  };
}
