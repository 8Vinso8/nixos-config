{
  inputs,
  ...
}:

{
  services.sing-box = {
    enable = true;
    settings  = builtins.fromJSON (inputs.secrets.singBoxConfig);
  };
}
