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

vim.lsp.enable("lua_ls")
vim.lsp.enable("nixd")
