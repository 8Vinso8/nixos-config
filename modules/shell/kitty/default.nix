{ pkgs, ... }:

{
  home-manager.users.vinso = {
    programs.kitty = {
      enable = true;
      font = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
        size = 12;
      };
      settings = {
        cursor_shape = "beam";
        notify_on_cmd_finish = "unfocused";
      };
    };
  };
}
