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
        "ui.background" = "none";
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
          language-servers = [ "basedpyright" "ruff" ];

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
