{ ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "small";
        padding = {
          top = 1;
          right = 3;
        };
        color = {
          "1" = "38;2;203;166;247";
          "2" = "38;2;137;180;250";
        };
      };
      display = {
        separator = "  ";
        color = {
          separator = "38;2;88;91;112";
        };
        size = {
          ndigits = 1;
        };
        duration = {
          abbreviation = true;
          spaceBeforeUnit = "never";
        };
      };
      modules = [
        {
          type = "title";
          color = {
            user = "38;2;203;166;247";
            at = "38;2;108;112;134";
            host = "38;2;180;190;254";
          };
        }
        {
          type = "separator";
          string = "─";
        }
        {
          type = "os";
          key = " ";
          keyColor = "38;2;137;180;250";
          format = "{pretty-name}";
        }
        {
          type = "kernel";
          key = " ";
          keyColor = "38;2;203;166;247";
          format = "{release}";
        }
        {
          type = "uptime";
          key = "󰅐 ";
          keyColor = "38;2;250;179;135";
        }
        {
          type = "packages";
          key = "󰏖 ";
          keyColor = "38;2;249;226;175";
          format = "{all} (nix)";
        }
        {
          type = "wm";
          key = " ";
          keyColor = "38;2;180;190;254";
          format = "{pretty-name}";
        }
        {
          type = "terminal";
          key = " ";
          keyColor = "38;2;166;227;161";
          format = "{pretty-name}";
        }
        {
          type = "shell";
          key = " ";
          keyColor = "38;2;148;226;213";
          format = "{exe-name} {version}";
        }
        {
          type = "cpu";
          key = " ";
          keyColor = "38;2;243;139;168";
          format = "{name}";
        }
        {
          type = "gpu";
          key = "󰾲 ";
          keyColor = "38;2;242;205;205";
          format = "{name}";
        }
        {
          type = "memory";
          key = " ";
          keyColor = "38;2;203;166;247";
          format = "{used} / {total} ({percentage})";
        }
        "break"
        {
          type = "colors";
          symbol = "circle";
        }
      ];
    };
  };
}
