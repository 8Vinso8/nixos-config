{
  hostname,
  ...
}:

{
  networking.hostName = "${hostname}";
  networking.networkmanager.enable = true;
  services.resolved.enable = true;
  networking.firewall.enable = false;

  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };
}
