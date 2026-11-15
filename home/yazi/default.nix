{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;

    plugins = {
      mount = pkgs.yaziPlugins.mount;
    };

    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "M" ];
          run = "plugin mount";
          desc = "Open mount manager";
        }
      ];
    };
  };

  xdg.configFile."yazi/theme.toml".source = ./theme.toml;
}
