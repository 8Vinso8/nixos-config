{ ... }:

{
  home-manager.users.vinso = {
    services.mako = {
      enable = true;
      settings = {
        default-timeout = 3000;
        border-radius = 5;
        anchor = "top-center";

        background-color = "#000000";
        text-color = "#ffffff";
        border-color = "#cba6f7";
        progress-color = "over #313244";

        "urgency=high" = {
          border-color = "#fab387";
        };
      };
    };
  };
}
