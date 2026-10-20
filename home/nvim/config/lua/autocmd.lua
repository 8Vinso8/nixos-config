local augroup = vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

-- Запуск Treesitter подсветки при определении типа файла
vim.api.nvim_create_autocmd("FileType", {
  desc = "Start treesitter highlighting if parser exists",
  group = augroup,
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- Подсветка скопированного текста при янке
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight text on yank",
  group = augroup,
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Возврат курсора на место, где остановились
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Return to last cursor position",
  group = augroup,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Автоматическое выравнивание сплитов при ресайзе окна
vim.api.nvim_create_autocmd("VimResized", {
  desc = "Resize splits automatically when window is resized",
  group = augroup,
  callback = function()
    vim.cmd("wincmd =")
  end,
})

-- Закрытие служебных окон на 'q'
vim.api.nvim_create_autocmd("FileType", {
  desc = "Close informational buffers with 'q'",
  group = augroup,
  pattern = { "help", "man", "qf", "checkhealth", "lspinfo" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
