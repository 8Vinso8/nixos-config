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
      nixfmt-rfc-style
      nixd
    ];
    plugins = with pkgs.vimPlugins; [
      autoclose-nvim
    ];
    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
