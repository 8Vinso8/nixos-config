{ ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
      };
      display = {
        color = {
          keys = "blue";
          title = "red";
        };
      };
      modules = [
        "title"
        "os"
        "kernel"
        "uptime"
        "memory"
        "swap"
        "disk"
      ];
    };
  };
}
