{
  ...
}:

{
  programs.starship.enable = true;
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
      };
      modules = [
        "separator"
        "os"
        "kernel"
        "memory"
        "swap"
        "disk"
        "separator"
      ];
    };
  };
}
