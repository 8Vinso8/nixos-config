{ inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # For lsp to use flake instead of channels
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
}
