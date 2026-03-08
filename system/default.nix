{ ... }:

{
  imports = [
    ./default-settings.nix
    ./boot.nix
    ./network.nix
    ./fonts.nix
    ./nix-storage-optimise.nix
    ./nix-settings.nix
  ];
}
