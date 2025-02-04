{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "vinso";
  home.homeDirectory = "/home/vinso";
  home.packages = with pkgs; [
    vscode
    qbittorrent
    inputs.zen-browser.packages."${system}".default
    telegram-desktop
    uget
    unrar
    spotify
    (discord.override {
      withVencord = true;
    })
    nixfmt-rfc-style
    nil
    vlc
    jq
    gh
    yt-dlp
    ffmpeg
    lynx
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
      			command! -nargs=0 Format :call CocActionAsync('format')
      		'';
    extraLuaConfig = ''
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
    '';
    coc = {
      enable = true;
      settings = {
        languageserver = {
          nix = {
            command = "nil";
            filetypes = [ "nix" ];
            rootPatterns = [ "flake.nix" ];
            settings = {
              nil = {
                formatting = {
                  command = [ "nixfmt" ];
                };
              };
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
      name = "JetBrainsMono Nerd Font Mono";
      size = 13;
    };
    themeFile = "Dark_Pastel";
    settings = {
      disable_ligatures = "cursor";
      cursor_shape = "beam";
      cursor_beam_thickness = 1.5;
      cursor_blink_interval = 0;
      scrollback_lines = 10000;
      show_hyperlink_targets = "yes";
      repaint_delay = 6;
      notify_on_cmd_finish = "unfocused";
      enable_audio_bell = "no";
      remember_window_size = "no";
      initial_window_width = "110c";
      initial_window_height = "32c";
      background_opacity = 0.8;
      hide_window_decorations = "yes";
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_title_max_length = 15;
      wayland_enable_ime = "no";
    };
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
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
    enableFishIntegration = true;
    enableTransience = true;
  };

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
    ];
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
    };
    shellAbbrs = {
      vps = "ssh root@${inputs.secrets.vpsIp}";
      rtr = "ssh root@openwrt.lan";
      rsw = "sudo nixos-rebuild switch";
      flup = "sudo nix flake update --flake /etc/nixos";
    };
    preferAbbrs = true;
    interactiveShellInit = ''
      set fish_greeting 
      fastfetch
    '';
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
