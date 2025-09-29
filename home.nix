{ pkgs, zen-browser, ... }:

{
  imports = [
    zen-browser.homeModules.beta
  ];

  home.username = "vinso";
  home.homeDirectory = "/home/vinso";

  home.packages = with pkgs; [
  ];

  programs.git = {
    enable = true;
    userName = "Vinso";
    userEmail = "8vinso8@gmail.com";
  };

  programs.zen-browser.enable = true;

  home.stateVersion = "25.05";
}
