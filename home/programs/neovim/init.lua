vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.number = true;

vim.keymap.set("n", "ff", "call CocAction('format')", { remap = false })
