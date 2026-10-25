{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    plugins = with pkgs.fishPlugins; [
      {
        name = "hydro";
        src = hydro.src;
      }
      {
        name = "fzf-fish";
        src = fzf-fish.src;
      }
    ];
    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -lh --icons --group-directories-first";
      lt = "eza --tree --icons";
    };
    interactiveShellInit = ''
      set -g fish_greeting

      # Hydro prompt settings
      set -g hydro_symbol_prompt "❯"
      set -gx hydro_color_prompt green

      fish_config theme choose catppuccin-mocha

      # Search hidden files in fzf.fish, excluding .git
      set -g fzf_fd_opts --hidden --exclude=.git

      # Catppuccin Mocha palette for FZF
      set -gx FZF_DEFAULT_OPTS " \
      --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
      --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
      --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
      --color=selected-bg:#45475a \
      --multi"
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
  };
  programs.eza.enable = true;
  programs.eza.enableBashIntegration = false; # prevents spam in nix-shell
  home.packages = with pkgs; [
    fd
    bat
  ];
}
