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
      size = 8 * 1024; # 8 GiB
      priority = 10;
    }
  ];

  boot.kernel.sysctl = {
    # Prioritize ZRAM over disk swap with aggressive swappiness
    "vm.swappiness" = 180;
    # Disable swap readahead (recommended for ZRAM and SSDs)
    "vm.page-cluster" = 0;
  };
}
