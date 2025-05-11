{
  pkgs,
  inputs,
  ...
}:

{
  home.username = "vinso";
  home.homeDirectory = "/home/vinso";

  home.packages = with pkgs; [
    inputs.zen-browser.packages."${system}".default
    spotify
    discord
    fd
    playerctl
  ];

  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting ""
    '';
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    changeDirWidgetCommand = "fd --type d --exclude .git --follow --hidden";
    defaultCommand = "fd --type f --exclude .git --follow --hidden";
    fileWidgetCommand = "fd --type f --exclude .git --follow --hidden";
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.git = {
    enable = true;
    userName = "Vinso";
    userEmail = "8vinso8@gmail.com";
    extraConfig = {
      url = {
        "ssh://git@github.com" = {
          insteadOf = "https://github.com";
        };
      };
    };
  };

  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
