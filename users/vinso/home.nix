{
  pkgs,
  inputs,
  ...
}:

{
  imports = [ 
    ../../home
    ../../home/hypr
    ../../home/autostart
    ../../home/programs/neovim
    ../../home/programs/kitty.nix
    ../../home/shells/fish
    ../../home/programs/yazi
  ];

  home.username = "vinso";
  home.homeDirectory = "/home/vinso";
  home.packages = with pkgs; [
    qbittorrent
    inputs.zen-browser.packages."${system}".default
    telegram-desktop
    spotify
    (discord.override {
      withVencord = true;
    })
    vlc
    htop
  ];

  programs.yazi = {
    enable = true;
    settings = {
      manager = {
        show_hidden = true;
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Vinso";
    userEmail = "8vinso8@gmail.com";
    extraConfig = {
      url = {
        "ssh://git@github.com" = {
          insteadOf = "https://github.com";
        };
      };
    };
  };

  programs.starship = {
    enable = true;
    enableTransience = true;
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
      };
      modules = [
        "separator"
        "os"
        "kernel"
        "memory"
        "swap"
        "disk"
        "separator"
      ];
    };
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
