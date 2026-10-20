{ pkgs, inputs, ... }:

let
  myNeovim = inputs.wrappers.lib.evalPackage ({ wlib, ... }: {
    imports = [ wlib.wrapperModules.neovim ];

    inherit pkgs;

    # Startup plugins pre-compiled and provided from nixpkgs
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
      ]))
    ];

    # External tools that Neovim will find in PATH
    runtimePkgs = with pkgs; [
      lua-language-server
      nixd
      nixfmt
      ripgrep
      fd
      gcc
    ];

    # Directory with your regular Lua configuration
    settings.config_directory = ./config;
  });
in
{
  home.packages = [ myNeovim ];

  # Alias nvim as default editor
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
