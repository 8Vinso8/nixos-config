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

  xdg.desktopEntries.yazi = {
    name = "Yazi File Manager";
    comment = "Blazing fast terminal file manager written in Rust, based on async I/O";
    icon = "yazi";
    exec = "xdg-terminal-exec yazi %f";
    terminal = false;
    categories = [
      "System"
      "FileManager"
      "FileTools"
      "ConsoleOnly"
    ];
    mimeType = [
      "inode/directory"
    ];
    settings = {
      Keywords = "File;Manager;Explorer;Browser;Launcher";
    };
  };
}
