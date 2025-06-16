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
      theme = "mocha";
    };
    themes.mocha = lib.importTOML ./mocha.toml;
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
      }
    ];
  };
}
