{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    secrets.url = "git+ssh://git@github.com/8Vinso8/secrets.git";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
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
        firewake = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/firewake
            ./users/vinso
            {
              users.users.vinso.extraGroups = [ "adbusers" ];
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.vinso = {
                imports = [
                  ./users/vinso/home.nix
                  ./home/hypr
                  ./home/autostart
                  ./home/packages
                  ./home/dev/direnv
                ];
                wayland.windowManager.hyprland = {
                  settings = {
                    monitor = [
                      "DP-1, 2560x1440@165, 0x0, 1"
                    ];
                  };
                };
              };
            }
          ];
        };
        swamp = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            .hosts/swamp
            .users/axe
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.axe = {
                imports = [
                  ./users/axe/home/nix
                  ./home/packages/normie.nix
                ];
              };
            }
          ];
        };
      };
    };
}
