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

  programs.fish.enable = true;
  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      nixd
      nixfmt
    ];
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        cursorline = true;
        preview-completion-insert = false;
        rulers = [ 80 ];
        color-modes = true;
        trim-trailing-whitespace = true;
        popup-border = "all";
        cursor-shape.insert = "bar";
        indent-guides.render = true;
        soft-wrap.enable = true;
      };
    };
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

  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font Mono";
      size = 12;
    };
    settings = {
      tab_bar_style = "powerline";
      notify_on_cmd_finish = "unfocused";
    };
  };

  programs.fastfetch.enable = true;

  programs.git = {
    enable = true;
    userName = "Vinso";
    userEmail = "8vinso8@gmail.com";
  };

  programs.zen-browser.enable = true;

  home.stateVersion = "25.05";
}
