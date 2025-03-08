{
  pkgs,
  ...
}:

{
  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      python313Packages.python-lsp-server
      nil
    ];
  };
}
