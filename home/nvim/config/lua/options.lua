vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Отключение неиспользуемых провайдеров
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- Номера строк
vim.opt.number = true
vim.opt.relativenumber = true

-- Табуляция и отступы
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Поиск
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

-- Внешний вид и поведение
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.numberwidth = 1
vim.opt.smoothscroll = true

-- Командная строка и статус
vim.opt.cmdheight = 0
vim.opt.showmode = false
vim.opt.laststatus = 3

-- Буфер обмена, история и тайминги
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
