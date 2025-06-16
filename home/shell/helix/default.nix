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
        true-color = true;
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
