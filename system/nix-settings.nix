{ inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # For lsp to use flake instead of channels
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  nix.optimise.automatic = true;
  nix.optimise.dates = [ "weekly" ];

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };
}
