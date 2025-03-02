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

local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end
  },
  sources = {
    { name = "nvim_lsp_signature_help"},
    { name = "nvim_lsp"},
    { name = "buffer"},
    { name = "path"}
  },
  mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
})
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require("lspconfig")
lspconfig.basedpyright.setup{
  capabilities = capabilities
}
lspconfig.nixd.setup{
  capabilities = capabilities
}
lspconfig.ruff.setup{
  capabilities = capabilities
}

vim.cmd 'colorscheme vscode'

require("autoclose").setup()
