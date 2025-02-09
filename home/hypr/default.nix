{
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    extraConfig = builtins.readFile ./hyprland.conf;
    settings = { };
  };

  programs.fish.loginShellInit = ''
    if uwsm check may-start -q;
      and test (tty) = /dev/tty1;
      and test -z $DISPLAY;
      exec uwsm start hyprland-uwsm.desktop
    end
  '';

  programs.kitty.enable = true;
}
