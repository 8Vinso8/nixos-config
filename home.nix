{ config, pkgs, inputs, ...}:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];


  home.username = "vinso";
  home.homeDirectory = "/home/vinso";
  home.packages = with pkgs; [];
  programs.git = {
    enable = true;
    userName = "Vinso";
    userEmail = "8vinso8@gmail.com";
  };
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting 
    '';
  };
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
  };
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };
  };
  home.stateVersion = "25.05";
}
