{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font";
    font.package = pkgs.nerd-fonts.jetbrains-mono;
    font.size = 11;
    settings = {
      tab_bar_style = "powerline";
      background_opacity = 0.7;
      notify_on_cmd_finish = "unfocused";
    };
  };
}
