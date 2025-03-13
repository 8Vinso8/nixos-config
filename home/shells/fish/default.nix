{
  inputs,
  pkgs,
  ...
}:

{
  programs.starship.enableFishIntegration = true;
  programs.starship.enableTransience = true;
  programs.yazi.enableFishIntegration = true;
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
  home.packages = with pkgs; [
    eza
  ];
  programs.bash = {
    enable = true;
    initExtra  = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
    ];
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "ls" = "eza -al --color=always --group-directories-first";
      "la" = "eza -a --color=always --group-directories-first";
      "ll" = "eza -l --color=always --group-directories-first";
      "lt" = "eza -aT --color=always --group-directories-first";
    };
    shellAbbrs = {
      vps = "ssh root@${inputs.secrets.vpsIp}";
      rtr = "ssh root@openwrt.lan";
      rsw = "sudo nixos-rebuild switch";
      flup = "sudo nix flake update --flake /etc/nixos";
    };
    preferAbbrs = true;
    interactiveShellInit = ''
      set fish_greeting
      fastfetch
    '';
  };
}
