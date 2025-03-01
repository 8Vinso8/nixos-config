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
    ];
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      autoclose-nvim
    ];
    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
