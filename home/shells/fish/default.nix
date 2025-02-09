{
  inputs,
  pkgs,
  ...
}:

{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
    ];
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
    };
    shellAbbrs = {
      vps = "ssh root@${inputs.secrets.vpsIp}";
      rtr = "ssh root@openwrt.lan";
      rsw = "sudo nixos-rebuild switch";
      flup = "sudo nix flake update --flake /etc/nixos";
    };
    preferAbbrs = true;
    interactiveShellInit = ''
      set fish_greeting
      fastfetch
    '';
  };
}
