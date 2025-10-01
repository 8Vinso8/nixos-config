{
  pkgs,
  zen-browser,
  hostname,
  ...
}:

{
  imports = [ zen-browser.homeModules.beta ];

  home.username = "vinso";
  home.homeDirectory = "/home/vinso";

  home.packages = with pkgs; [
  ];

  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
      nixfmt
    ];
    languages = {
      language-server = {
        nixd = {
          config.nixd = {
            nixpkgs.expr = "import (builtins.getFlake (toString /etc/nixos)).inputs.nixpkgs { }";
            options = {
              nixos.expr = "(builtins.getFlake (toString /etc/nixos)).nixosConfigurations.${hostname}.options";
              home-manager.expr = "(builtins.getFlake (toString /etc/nixos)).nixosConfigurations.${hostname}.options.home-manager.users.type.getSubOptions []";
            };
          };
        };
      };
    };
  };

  programs.kitty.enable = true;
  
  programs.git = {
    enable = true;
    userName = "Vinso";
    userEmail = "8vinso8@gmail.com";
  };

  programs.zen-browser.enable = true;

  home.stateVersion = "25.05";
}
