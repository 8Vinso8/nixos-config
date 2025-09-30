{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets.url = "git+ssh://git@github.com/8Vinso8/secrets.git";
  };

  outputs = { nixpkgs, secrets, home-manager, zen-browser, ... }@inputs: {
    nixosConfigurations.nixvm = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit secrets; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.vinso = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit zen-browser; };
          }
      ];
    };
  };
}
