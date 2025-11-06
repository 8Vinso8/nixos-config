{ pkgs, ... }:

{
  home-manager.users.vinso = {
    programs.helix = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        nixd
        nixfmt
      ];
    };
  };
}
