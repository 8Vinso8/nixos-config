{ ... }:

{
  imports = [
    ./home/shell
    ./home/de/niri
  ];
  home.username = "vinso";
  home.homeDirectory = "/home/vinso";
  programs.git = {
    enable = true;
    userName = "Vinso";
    userEmail = "8vinso8@gmail.com";
  };
  home.stateVersion = "25.05";
}
