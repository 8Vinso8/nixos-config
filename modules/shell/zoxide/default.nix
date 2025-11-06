{ ... }:

{
  home-manager.users.vinso = {
    programs.zoxide = {
      enable = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
