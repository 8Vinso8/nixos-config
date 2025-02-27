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
    ];
    shell = pkgs.fish;
  };
}
