{ ... }:

{
  services.mako = {
    enable = true;
    settings = {
      font = "JetBrainsMono Nerd Font 10";
      format = "<b>%s</b>\\n%b";
      icons = 1;
      max-icon-size = 48;
      icon-location = "left";

      default-timeout = 2500;
      ignore-timeout = 1;

      anchor = "bottom-right";
      max-visible = 2;
      sort = "-time";

      width = 320;
      height = 100;
      margin = 6;
      padding = 10;
      border-size = 1;
      border-radius = 8;

      background-color = "#11111b";
      text-color = "#cdd6f4";
      border-color = "#cba6f7";
      progress-color = "over #313244";

      on-button-left = "dismiss";
      on-button-right = "dismiss-all";
      on-button-middle = "none";

      "urgency=critical" = {
        border-color = "#f38ba8";
        default-timeout = 0;
      };
    };
  };
}
