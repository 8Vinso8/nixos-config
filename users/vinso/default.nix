{
  pkgs,
  ...
}:

{
  users.users.vinso = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "adbusers"
    ];
    shell = pkgs.fish;
  };
}
