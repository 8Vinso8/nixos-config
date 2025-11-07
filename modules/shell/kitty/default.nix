{ pkgs, ... }:

{
  home-manager.users.vinso = {
    programs.kitty = {
      enable = true;
      font = {
        package = pkgs.monaspace;
        name = "Monaspace Neon Frozen";
        size = 12;
      };
      settings = {
        cursor_shape = "beam";
        notify_on_cmd_finish = "unfocused";
      };
    };
  };
}
