{
  pkgs,
  zen-browser,
  catppuccin,
  hostname,
  ...
}:

{
  imports = [
    zen-browser.homeModules.beta
    catppuccin.homeModules.catppuccin
  ];

  home.username = "vinso";
  home.homeDirectory = "/home/vinso";

  home.packages = with pkgs; [
  ];

  programs.vesktop.enable = true;

  catppuccin = {
    flavor = "mocha";
    accent = "mauve";
    fish.enable = true;
    fzf.enable = true;
    helix.enable = true;
    kitty.enable = true;
    starship.enable = true;
    yazi.enable = true;
  };

  programs.fish = {
    enable = true;
    functions = {
      fish_greeting = "";
    };
  };
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
    settings = builtins.fromTOML (
      builtins.readFile "${pkgs.starship}/share/starship/presets/pure-preset.toml"
    );
  };
  programs.fd.enable = true;
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultCommand = "fd --type f";
    fileWidgetCommand = "fd --type f";
    changeDirWidgetCommand = "fd --type d";
  };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    extraOptions = [
      "--all"
      "--group-directories-first"
    ];
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      nixd
      nixfmt
    ];
    settings = {
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
