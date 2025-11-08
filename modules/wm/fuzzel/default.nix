{ ... }:

{
  home-manager.users.vinso = {
    programs.fuzzel = {
      enable = true;
      settings = {

        main = {
          terminal = "kitty -e";
          match-mode = "fuzzy";
          font = "monospace:size=14";
          use-bold = "yes";
          icons-enabled = "no";
          lines = 10;
          width = 20;
          horizontal-pad = 10;
        };

        colors = {
          background = "000000ff";
          text = "ffffffff";
          prompt = "00ff00ff";
          input = "ffffffff";
          match = "ff0000ff";
          selection = "00000000";
          selection-text = "f38ba8ff";
          selection-match = "ff0000ff";
          border = "cba6f7ff";
        };

        border = {
          width = 2;
        };
      };
    };
  };
}
