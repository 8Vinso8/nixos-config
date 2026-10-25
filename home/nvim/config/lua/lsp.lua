vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
  },
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = " ",
      [vim.diagnostic.severity.INFO]  = " ",
    },
  },
  underline = true,
  update_in_insert = false,
})

-- Передаем capabilities от blink.cmp во все LSP-серверы
local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.config("nixd", {
  settings = {
    nixd = {
      nixpkgs = {
        expr = 'import (builtins.getFlake ("git+file://" + toString /etc/nixos)).inputs.nixpkgs { }',
      },
      formatting = {
        command = { "nixfmt" },
      },
      options = {
        nixos = {
          expr = '(builtins.getFlake ("git+file://" + toString /etc/nixos)).nixosConfigurations.firewake.options',
        },
        ["home-manager"] = {
          expr = '((builtins.getFlake ("git+file://" + toString /etc/nixos)).nixosConfigurations.firewake.options.home-manager.users.type.getSubOptions [] )',
        },
      },
    },
  },
})

vim.lsp.config("ts_ls", {
  init_options = {
    preferences = {
      semicolons = "remove",
    },
  },
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("nixd")
vim.lsp.enable("ts_ls")
vim.lsp.enable("cssls")
