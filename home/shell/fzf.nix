{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fd
  ];
  programs.fzf = {
    enable = true;
    changeDirWidgetCommand = "fd --type d --exclude .git --follow --hidden"; # Alt-c
    defaultCommand = "fd --type f --exclude .git --follow --hidden"; # Default
    fileWidgetCommand = "fd --type f --exclude .git --follow --hidden"; # ctrl-t
  };
}
