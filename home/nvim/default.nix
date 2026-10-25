{ pkgs, inputs, ... }:

let
  myNeovim = inputs.wrappers.lib.evalPackage (
    { wlib, ... }: {
      imports = [ wlib.wrapperModules.neovim ];

      inherit pkgs;

      specs.general = with pkgs.vimPlugins; [
        catppuccin-nvim
        mini-icons
        oil-nvim
        plenary-nvim
        telescope-nvim
        telescope-fzf-native-nvim
        lualine-nvim
        which-key-nvim
        blink-cmp
        nvim-autopairs
        lazydev-nvim
        nvim-lspconfig
        (nvim-treesitter.withPlugins (p: [
          p.lua
          p.nix
          p.bash
          p.yaml
          p.json
          p.markdown
          p.toml
          p.vim
          p.typescript
          p.tsx
          p.javascript
          p.css
          p.scss
        ]))
      ];

      runtimePkgs = with pkgs; [
        lua-language-server
        nixd
        nixfmt
        ripgrep
        fd
        gcc
        typescript-language-server
        typescript
        vscode-langservers-extracted
      ];

      settings.config_directory = ./config;
    }
  );
in
{
  home.packages = [ myNeovim ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
