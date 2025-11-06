{ pkgs, ... }:

{
  home-manager.users.vinso.programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile "${pkgs.starship}/share/starship/presets/pure-preset.toml");
  };
}
