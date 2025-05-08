{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "vinso";
  home.homeDirectory = "/home/vinso";

  home.packages = with pkgs; [
    inputs.zen-browser.packages."${system}".default
    spotify
    discord
  ];

  programs.git = {
    enable = true;
    userName = "Vinso";
    userEmail = "8vinso8@gmail.com";
    extraConfig = {
      url = {
        "ssh://git@github.com" = {
          insteadOf = "https://github.com";
        };
      };
    };
  };

  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
