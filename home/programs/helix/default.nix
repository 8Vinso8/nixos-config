{
  pkgs,
  ...
}:

{
  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
      nixfmt-rfc-style
      ruff
      basedpyright
      vscode-langservers-extracted
    ];
    settings = {
      theme = "my_theme";
      editor = {
        cursorline = true;
        completion-timeout = 5;
        completion-replace = true;
        rulers = [ 80 ];
        color-modes = true;
        popup-border = "all";
        true-color = true;
        file-picker = {
          hidden = false;
        };
        indent-guides = {
          render = true;
          character = "╎";
        };
        gutters = {
          layout = [
            "line-numbers"
            "diagnostics"
          ];
          line-numbers.min-width = 1;
        };
        soft-wrap = {
          enable = true;
        };
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "warning";
        };
      };
    };
    themes = {
      my_theme = {
        inherits = "catppuccin_mocha";
        "ui.background" = {
          bg = "none";
        };
        "ui.cursor.primary.normal" = {
          fg = "#000000";
          bg = "#FFFFFF";
        };
        "ui.cursor.primary.insert" = {
          fg = "#000000";
          bg = "#00FF00";
        };
        "ui.cursor.primary.select" = {
          fg = "#000000";
          bg = "#FF0000";
        };
      };
    };
    languages = {
      language = [
        {
          name = "nix";
          language-servers = [ "nixd" ];
          formatter = {
            command = "nixfmt";
          };
        }
        {
          name = "python";
          language-servers = [
            "basedpyright"
            "ruff"
          ];
        }
      ];
      language-server = {
        ruff = {
          command = "ruff";
          args = [ "server" ];
        };
      };
    };
  };
}
