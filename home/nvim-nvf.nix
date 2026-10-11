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

    mini.icons.enable = true;
    luaConfigPost = ''
      require("mini.icons").mock_nvim_web_devicons()
    '';

    autocomplete.blink-cmp = {
      enable = true;
      setupOpts = {
        cmdline.keymap.preset = "default";
        keymap = {
          preset = "enter";
          "<Tab>" = [
            "select_next"
            "snippet_forward"
            "fallback"
          ];

          "<S-Tab>" = [
            "select_prev"
            "snippet_backward"
            "fallback"
          ];
        };

        completion.list.selection = {
          preselect = false;
          auto_insert = false;
        };
      };
    };

    utility.oil-nvim = {
      enable = true;
      gitStatus.enable = true;
      setupOpts.view_options.show_hidden = true;
    };

    autopairs.nvim-autopairs.enable = true;

    telescope = {
      enable = true;
      extensions = [
        {
          name = "fzf";
          packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
          setup = {
            fzf = {
              fuzzy = true;
            };
          };
        }
      ];
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
      "-" = {
        action = "<cmd>Oil<CR>";
        desc = "launch oil";
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

    languages.lua = {
      enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };
    lsp.servers.lua-language-server.settings.Lua = {
      workspace.library = [ "/run/current-system/sw/share/hypr/stubs" ];
    };

    options = {
      number = true;
      relativenumber = true;

      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;

      ignorecase = true;
      smartcase = true;

      termguicolors = true;
      cursorline = true;
      signcolumn = "yes";
      wrap = false;
      scrolloff = 8;
      splitright = true;
      splitbelow = true;
      numberwidth = 1;

      cmdheight = 0;
      showmode = false;
      laststatus = 3;
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
