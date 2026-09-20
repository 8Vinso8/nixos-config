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

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nixpkgs-throne.url = "github:NixOS/nixpkgs/pull/550661/head";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-cachyos-kernel,
      nixpkgs-throne,
      ...
    }@inputs:
    {
      nixosConfigurations = {

        firewake =
          let
            hostname = "firewake";
            stateVersion = "26.05";
          in
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs hostname stateVersion; };
            modules = [
              ./configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit inputs hostname stateVersion; };
                  users.vinso = import ./home.nix;
                };
              }
            ];
          };

      };
    };
}
