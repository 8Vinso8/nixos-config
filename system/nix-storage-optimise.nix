{ ... }:

{
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "weekly" ];

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };
}
