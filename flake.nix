{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
      system = "x86_64-linux";
      # lib = nixpkgs.lib;
      extraSpecialArgs = { inherit system inputs; };  # <- passing inputs to the attribute set for home-manager
      specialArgs = { inherit system inputs; };       # <- passing inputs to the attribute set for NixOS (optional)
    in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager = {
      	      inherit extraSpecialArgs;
              useGlobalPkgs = true;
              useUserPackages = true;
              users.nuc = import ./home.nix;
	          };
          }
        ];
      specialArgs = specialArgs;
    };
  };
}
