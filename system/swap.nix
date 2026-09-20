{ ... }:

{
  zramSwap = {
    enable = true;
    memoryPercent = 100;
    priority = 100;
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 16 * 1024; # 16 GiB
      priority = 10;
    }
  ];
}
