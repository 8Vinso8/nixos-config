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
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    {
      nixpkgs,
      secrets,
      home-manager,
      zen-browser,
      catppuccin,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        nixvm = nixpkgs.lib.nixosSystem {
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
                  inherit zen-browser catppuccin;
                };
                users.vinso = import ./home.nix;
              };
            }
          ];
        };
        firewake = nixpkgs.lib.nixosSystem {
          specialArgs = {
            hostname = "firewake";
            inherit secrets;
          };
          modules = [
            ./hosts/firewake
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  hostname = "firewake";
                  inherit zen-browser catppuccin;
                };
                users.vinso = import ./home.nix;
              };
            }
          ];
        };
      };
    };
}
