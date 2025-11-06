{ pkgs, ... }:

{
  services.udisks2.enable = true;
  home-manager.users.vinso = {
    home.packages = [ pkgs.udisks ];
    programs.yazi = {
      enable = true;
      plugins = {
        mount = pkgs.yaziPlugins.mount;
      };
      keymap = {
        mgr.prepend_keymap = [
          {
            on = "M";
            run = "plugin mount";
          }
        ];
      };
    };
  };
}
