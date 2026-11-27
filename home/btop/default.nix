{ ... }:

{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_mocha";
      vim_keys = true;
      rounded_corners = false;
      update_ms = 1500;
      save_config_on_exit = false;
    };
    themes = {
      catppuccin_mocha = ./catppuccin_mocha.theme;
    };
  };
}
