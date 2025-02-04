vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.number = true;

vim.lsp.config['nil_ls'] = {
  cmd = { 'nil' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix' },
}

vim.lsp.enable('nil_ls')
