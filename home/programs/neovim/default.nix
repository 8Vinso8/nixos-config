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
    ];
    extraLuaConfig = builtins.readFile ./init.lua;
    coc = {
      enable = true;
      settings = {
        languageserver = {
          nix = {
            command = "nixd";
            filetypes = [ "nix" ];
            rootPatterns = [
              "flake.nix"
            ];
            settings = {
              nixd = {
                formatting = {
                  command = [ "nixfmt" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
