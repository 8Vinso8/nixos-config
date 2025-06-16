{ pkgs, lib, ... }:

{
  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
      nil
      nixfmt-rfc-style
    ];
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        cursorline = true;
        preview-completion-insert = false;
        true-color = true;
        rulers = [ 120 ];
        popup-border = "all";
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
      }
    ];
  };
}
