{
  hostname,
  ...
}:

{
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  services.resolved.enable = true;
  networking.firewall.enable = false;

  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };

  # Workaround for Throne TUN mode: allow wheel users (and ThroneCore) to flush DNS cache
  # without password prompt. Can be removed once fixed upstream in nixpkgs:
  # https://github.com/NixOS/nixpkgs/issues/590716
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id === "org.freedesktop.resolve1.flush-caches" &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';
}
