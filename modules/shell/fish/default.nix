{ pkgs, ... }:

{
  programs.fish.enable = true;
  users.users.vinso.shell = pkgs.fish;

  home-manager.users.vinso = {
    programs.fish = {
      enable = true;
      functions = {
        fish_greeting = "";
      };
    };

    programs.kitty.shellIntegration.enableFishIntegration = true;

    programs.starship = {
      enableFishIntegration = true;
      enableTransience = true;
    };

    programs.yazi.enableFishIntegration = true;

    programs.fzf.enableFishIntegration = true;

    programs.zoxide.enableFishIntegration = true;
  };
}
