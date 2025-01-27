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
    vlc
    jq
  ];

  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 14;
    };
    settings = {
      disable_ligatures = "cursor";
      cursor_shape = "beam";
      cursor_beam_thickness = 1.5;
      cursor_blink_interval = 0;
      scrollback_lines = 10000;
      show_hyperlink_targets = "yes";
      repaint_delay = 6;
    };
    extraConfig = ''
      remote_control_password "kitty-rc-password" ls
      allow_remote_control password
    '';
  };

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
    enableTransience = true;
  };

  programs.fish = {
    enable = true;
    plugins = [
      { name = "done"; src = pkgs.fishPlugins.done.src; }
      { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
    ];
    interactiveShellInit = ''
      set fish_greeting 
      alias vps="ssh root@${inputs.secrets.vpsIp}"
      alias router="ssh root@openwrt.lan"
      set -U __done_kitty_remote_control 1
      set -U __done_kitty_remote_control_password "kitty-rc-password"
    '';
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
