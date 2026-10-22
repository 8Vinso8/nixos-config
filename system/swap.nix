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
    # Приоритет отдаётся ZRAM перед дисковым swap'ом, агрессивное сжатие
    "vm.swappiness" = 180;
    # Отключение readahead страниц подкачки (рекомендовано для ZRAM и SSD)
    "vm.page-cluster" = 0;
  };
}
