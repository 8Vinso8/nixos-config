{ ... }:

{
  services.hypridle.enable = true;
  services.hypridle.settings = {
    listener = [
      {
        timeout = 1800;
        on-timeout = "systemctl sleep";
      }
    ];
  };
}
