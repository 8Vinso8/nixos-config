{
  ...
}:

{
  services.mako = {
    enable = true;
    anchor = "top-center";
    backgroundColor = "#000000EE";
    borderColor = "#33CCFFEE";
    borderRadius = 10;
    borderSize = 2;
    defaultTimeout = 2000;
    layer = "top";
    maxVisible = 2;
    extraConfig = ''
      [summary=" "]
      format=%b
    '';
  };
}
