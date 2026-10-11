{ ... }:

{
  zramSwap = {
    enable = true;
    memoryPercent = 100;
    priority = 100;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024; # 16 GiB
      priority = 10;
    }
  ];
}
