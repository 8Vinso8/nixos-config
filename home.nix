{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "vinso";
  home.homeDirectory = "/home/vinso";
  home.packages = with pkgs; [
    vscode
    qbittorrent
    ghostty
    inputs.zen-browser.packages."${system}".default
    telegram-desktop
    uget
    unrar
    spotify
    (discord.override {
      withVencord = true;
    })
    fastfetch
    nixfmt-rfc-style
  ];

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Vinso";
    userEmail = "8vinso8@gmail.com";
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting 
      alias router="ssh root@openwrt.lan"
      alias vps="ssh root@${inputs.secrets.vpsIp}"
    '';
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
