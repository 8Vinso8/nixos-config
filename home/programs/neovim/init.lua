vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.number = true;
vim.opt.updatetime = 250;

vim.diagnostic.config {
  update_in_insert = true,
  underline = true,
  float = { 
    border = "single",
    header = "",
    source = "always",
    scope = "cursor"
  }
}

vim.api.nvim_create_autocmd({"CursorHold"}, {
  pattern = "*",
  callback = function()
    local opts = {
      focusable = false,
    }
    vim.diagnostic.open_float(nil, opts)
  end
})

vim.keymap.set("n", "ff", vim.lsp.buf.format, { remap = false })

local lspconfig = require("lspconfig")
lspconfig.basedpyright.setup{}
lspconfig.nixd.setup{}

require("autoclose").setup()
