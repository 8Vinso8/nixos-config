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
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-cachyos-kernel,
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
            system = "x86_64-linux";
            specialArgs = { inherit inputs hostname stateVersion; };
            modules = [
              (
                { pkgs, ... }:
                {
                  nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
                    boot.kernelPackages = pkgs.cachyosKernels.linux-cachyos-latest-x86_64-v3;
                    #boot.kernelPackages = pkgs.linuxPackages_latest;

                  # Binary cache
                    #nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
                    #nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
                }
              )
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
            ];
          };

      };
    };
}
