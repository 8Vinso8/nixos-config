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
