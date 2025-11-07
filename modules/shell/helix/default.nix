{ pkgs, ... }:

{
  home-manager.users.vinso = {
    programs.helix = {
      enable = true;
      defaultEditor = true;

      extraPackages = with pkgs; [
        nixd
        nixfmt
      ];

      settings = {
        theme = "custom_tr_bg";
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

      themes = {
        custom_tr_bg = {
          inherits = "catppuccin_mocha";
          "ui.background" = "none";
        };
      };

      languages = {
        language = [
          {
            name = "nix";
            auto-format = true;
          }
        ];
        language-server = {
          nixd = {
            args = [ "--semantic-tokens=true" ];
            config.nixd =
              let
                myFlake = "(builtins.getFlake \"/etc/nixos\")";
                nixosOpts = "${myFlake}.nixosConfigurations.firewake.options";
              in
              {
                nixpkgs.expr = "import ${myFlake}.inputs.nixpkgs { }";
                options = {
                  nixos.expr = nixosOpts;
                  home-manager.expr = "${nixosOpts}.home-manager.users.type.getSubOptions []";
                };
              };
          };
        };
      };
    };
  };
}
