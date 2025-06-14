{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];
  home.username = "vinso";
  home.homeDirectory = "/home/vinso";
  home.packages = with pkgs; [
    fd
  ];
  programs.git = {
    enable = true;
    userName = "Vinso";
    userEmail = "8vinso8@gmail.com";
  };
  programs.fish = {
    enable = true;
    functions = {
      fish_greeting = "";
      starship_transient_prompt_func = "starship module character";
    };
  };
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
    settings = {
      format = "($username$hostname )$directory$git_branch$git_status$line_break$character";
      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style))";
        style = "cyan";
        ahead = ">";
        behind = "<";
        diverged = "<>";
        renamed = "r";
        deleted = "x";
      };
      git_branch = {
        format = "\\[[$branch(:$remote_branch)]($style)\\]";
        style = "bright-black";
      };
      username = {
        format = "\\[[$user]($style)\\]";
        style_root = "bold red";
        style_user = "bold green";
      };
      hostname = {
        format = "\\[[$hostname]($style)\\]";
        style = "green";
      };
      directory = {
        style = "cyan";
        truncate_to_repo = false;
        read_only = "[RO]";
      };
      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[X](bold red)";
      };
    };
  };
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    changeDirWidgetCommand = "fd --type d --exclude .git --follow --hidden"; # Alt-c
    defaultCommand = "fd --type f --exclude .git --follow --hidden"; # Default
    fileWidgetCommand = "fd --type f --exclude .git --follow --hidden"; # ctrl-t
  };
  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };
    diagnostic.settings = {
      virtual_lines = {
        current_line = true;
      };
      virtual_text = false;
    };
    opts = {
      number = true;
      expandtab = true;
      cursorline = true;
      smartcase = true;
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
    };
    extraPackages = with pkgs; [
      nixfmt-rfc-style
    ];
    plugins.lspconfig.enable = true;
    plugins.indent-blankline.enable = true;
    plugins.cmp = {
      enable = true;
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "vsnip"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
      settings.mapping = {
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}))";
        "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}))";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
      };
      settings.preselect = "cmp.PreselectMode.None";
    };
    lsp.inlayHints.enable = true;
    lsp.servers.nixd.enable = true;
    lsp.servers.nixd.settings = {
      formatting.command = [ "nixfmt" ];
    };
    lsp.keymaps = [
      {
        key = "ff";
        lspBufAction = "format";
      }
      {
        key = "ca";
        lspBufAction = "code_action";
      }
    ];
  };
  home.stateVersion = "25.05";
}
