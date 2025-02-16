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

vim.lsp.config['nixd'] = {
  cmd = { 'nixd' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix' },
  settings = {
    nixd = {
      formatting = {
        command = { 'nixfmt' },
      },
    },
  },
}

vim.lsp.enable('nixd')
require("autoclose").setup()
