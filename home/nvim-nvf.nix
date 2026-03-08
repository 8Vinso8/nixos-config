{
  inputs,
  hostname,
  lib,
  pkgs,
  ...
}:

{
  imports = [ inputs.nvf.homeManagerModules.default ];

  home.packages = with pkgs; [
    nixd
    nixfmt
  ];

  programs.nvf.enable = true;

  programs.nvf.settings.vim = {

    autocomplete.blink-cmp = {
      enable = true;
      setupOpts.cmdline.keymap.preset = "default";
    };

    filetree.nvimTree = {
      enable = true;

      setupOpts.view = {
        signcolumn = "no";
        width = {
          max = -1;
          min = -1;
          padding = 1;
        };
      };
      setupOpts.actions.open_file.resize_window = true;
      setupOpts.git.enable = true;
    };

    ui.noice.enable = true;

    maps.normal = {
      "<leader>f" = {
        action = "<cmd>lua vim.lsp.buf.format()<CR>";
        silent = true;
        desc = "Format document";
      };
      "<ESC>" = {
        action = "<cmd>nohlsearch<CR>";
        silent = true;
        desc = "Hide search highlight";
      };
    };

    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
    };

    binds.whichKey.enable = true;

    visuals.rainbow-delimiters.enable = true;

    statusline.lualine.enable = true;

    languages.nix = {
      enable = true;
      format.enable = true;
      format.type = [ "nixfmt" ];
      lsp.enable = true;
      lsp.servers = [ "nixd" ];
      treesitter.enable = true;
    };

    lsp.servers.nixd.settings.nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> {}";
      };
      options = {
        nixos = {
          expr = "(builtins.getFlake (builtins.toString /etc/nixos)).nixosConfigurations.${hostname}.options";
        };
        home-manager = {
          expr = "(builtins.getFlake (builtins.toString /etc/nixos)).nixosConfigurations.${hostname}.options.home-manager.users.type.getSubOptions []";
        };
      };
      diagnostic = {
        suppress = [ ];
      };
    };

    options = {
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      relativenumber = false;
      showmode = false;
      cmdheight = 0;
    };

    diagnostics = {
      enable = true;
      config.virtual_text = {
        format = lib.generators.mkLuaInline ''
          function(diagnostic)
            return string.format("%s (%s)", diagnostic.message, diagnostic.code)
          end
        '';
      };
    };
  };
}
