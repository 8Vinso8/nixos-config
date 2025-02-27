{
  pkgs,
  ...
}:

{
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    extraCompatPakcages = with pkgs; [
      proton-ge-bin
    ];
  };
}
