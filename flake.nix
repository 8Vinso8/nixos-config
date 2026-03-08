{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations = {

        firewake =
          let
            hostname = "firewake";
            # Change if fresh install
            stateVersion = "25.11";
          in
          nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs hostname stateVersion; };
            modules = [
              ./hosts/firewake/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit inputs hostname stateVersion; };
                  users.vinso = import ./users/vinso/home.nix;
                };
              }
              { nixpkgs.overlays = [ (import ./overlay) ]; }
            ];
          };

        nixvm =
          let
            hostname = "nixvm";
            # Change if fresh install
            stateVersion = "25.11";
          in
          nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs hostname stateVersion; };
            modules = [
              ./hosts/nixvm/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit inputs hostname stateVersion; };
                  users.vinso = import ./users/vinso-vm/home.nix;
                };
              }
              { nixpkgs.overlays = [ (import ./overlay) ]; }
            ];
          };

      };
    };
}
