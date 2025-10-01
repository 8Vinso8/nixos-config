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

  outputs =
    {
      nixpkgs,
      secrets,
      home-manager,
      zen-browser,
      ...
    }@inputs:
    {
      nixosConfigurations.nixvm = nixpkgs.lib.nixosSystem {
        specialArgs = {
          hostname = "nixvm";
          inherit secrets;
        };
        modules = [
          ./hosts/nixvm
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                hostname = "nixvm";
                inherit zen-browser;
              };
              users.vinso = import ./home.nix;
            };
          }
        ];
      };
    };
}
