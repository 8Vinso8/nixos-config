{
  hostname,
  ...
}:

{
  networking.hostName = hostname;
  networking.useNetworkd = true;
  services.resolved.enable = true;
  networking.firewall.enable = false;
  systemd.network.wait-online.enable = false;
  systemd.network.networks."10-lan" = {
    matchConfig.Name = "en*";
    networkConfig.DHCP = "yes";
  };

  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };
}
