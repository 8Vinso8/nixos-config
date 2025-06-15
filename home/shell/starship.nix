{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      format = "($username$hostname )$directory$git_branch$git_status$line_break$character";
      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style))";
        style = "cyan";
        ahead = ">";
        behind = "<";
        diverged = "<>";
        renamed = "r";
        deleted = "x";
      };
      git_branch = {
        format = "\\[[$branch(:$remote_branch)]($style)\\]";
        style = "bright-black";
      };
      username = {
        format = "\\[[$user]($style)\\]";
        style_root = "bold red";
        style_user = "bold green";
      };
      hostname = {
        format = "\\[[$hostname]($style)\\]";
        style = "green";
      };
      directory = {
        style = "cyan";
        truncate_to_repo = false;
        read_only = "[RO]";
      };
      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[X](bold red)";
      };
    };
  };
}
