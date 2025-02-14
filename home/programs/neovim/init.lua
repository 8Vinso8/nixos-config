vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.number = true;


vim.keymap.set("n", "ff", vim.lsp.buf.format, { remap = false })

vim.diagnostic.config({
  virtual_text = true,
  signs = false,
  float = true,
  update_in_insert = true
})
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
