{ pkgs, ... }:

{
  services.udisks2.enable = true;
  home-manager.users.vinso = {
    programs.yazi = {
      enable = true;
      package = pkgs.yazi.override { _7zz = pkgs._7zz-rar; };
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
