{
  inputs,
  pkgs,
  ...
}:

{
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      # Nix
      nixfmt-rfc-style
      nixd
      # Python
      basedpyright
      ruff
      # Lua
      lua-language-server
    ];
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      vscode-nvim
      autoclose-nvim
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-nvim-lsp
      cmp-cmdline
      cmp-nvim-lsp-signature-help
    ];
    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
