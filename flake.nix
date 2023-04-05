{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ args: {
    nixosConfigurations.tara = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = args;
      modules = [./tara.nix];
    };
  };
}
