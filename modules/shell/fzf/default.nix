{ pkgs, ... }:

{
  home-manager.users.vinso = {
    programs.fzf = {
      enable = true;
      defaultCommand = "fd --type f --exclude .git";
      fileWidgetCommand = "fd --type f --exclude .git";
      changeDirWidgetCommand = "fd --type d --exclude .git";
    };
    home.packages = [ pkgs.fd ];
  };

}
