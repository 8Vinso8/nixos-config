{ pkgs, inputs, ... }:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };
    diagnostic.settings = {
      virtual_lines = {
        current_line = true;
      };
      virtual_text = false;
    };
    opts = {
      number = true;
      expandtab = true;
      cursorline = true;
      smartcase = true;
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
    };
    extraPackages = with pkgs; [
      nixfmt-rfc-style
    ];
    plugins.lspconfig.enable = true;
    plugins.indent-blankline.enable = true;
    plugins.cmp = {
      enable = true;
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "vsnip"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
      settings.mapping = {
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}))";
        "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}))";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
      };
    };
    lsp.inlayHints.enable = true;
    lsp.servers.nixd.enable = true;
    lsp.servers.nixd.settings = {
      formatting.command = [ "nixfmt" ];
    };
    lsp.keymaps = [
      {
        key = "ff";
        lspBufAction = "format";
      }
      {
        key = "ca";
        lspBufAction = "code_action";
      }
    ];
  };
}
