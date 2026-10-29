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
          "1" = "38;2;137;180;250";
          "2" = "38;2;116;199;236";
        };
      };
      display = {
        separator = "  ";
        color = {
          separator = "38;2;88;91;112";
          keys = "38;2;203;166;247";
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
          format = "{pretty-name}";
        }
        {
          type = "kernel";
          key = " ";
          format = "{release}";
        }
        {
          type = "uptime";
          key = "󰅐 ";
        }
        {
          type = "packages";
          key = "󰏖 ";
          format = "{all} (nix)";
        }
        {
          type = "wm";
          key = " ";
          format = "{pretty-name}";
        }
        {
          type = "terminal";
          key = " ";
          format = "{pretty-name}";
        }
        {
          type = "shell";
          key = " ";
          format = "{exe-name} {version}";
        }
        {
          type = "cpu";
          key = " ";
          format = "{name}";
        }
        {
          type = "gpu";
          key = "󰾲 ";
          format = "{name}";
        }
        {
          type = "memory";
          key = " ";
          format = "{used} / {total} ({percentage})";
        }
        {
          type = "disk";
          key = "󰋊 ";
          format = "{size-free} free / {size-total}";
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
