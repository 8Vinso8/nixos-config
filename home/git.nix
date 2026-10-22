{ ... }:

{
  programs.git = {
    enable = true;
    ignores = [
      ".direnv/"
      ".envrc"
    ];
    settings = {
      user = {
        name = "Vinso";
        email = "8vinso8@gmail.com";
      };
    };
  };
}
