local builtin = require('telescope.builtin')

-- Telescope keymaps
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Diagnostics' })

-- LSP keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }

    vim.keymap.set("n", "gd", builtin.lsp_definitions, vim.tbl_extend("force", opts, { desc = "LSP definitions" }))
    vim.keymap.set("n", "gr", builtin.lsp_references, vim.tbl_extend("force", opts, { desc = "LSP references" }))
    vim.keymap.set("n", "gI", builtin.lsp_implementations, vim.tbl_extend("force", opts, { desc = "LSP implementations" }))
    vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, vim.tbl_extend("force", opts, { desc = "LSP document symbols" }))
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, vim.tbl_extend("force", opts, { desc = "Hover doc" }))
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
  end,
})

-- Diagnostic keymaps
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show line diagnostic" })
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })

-- Format code
vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, { desc = "Format buffer" })

-- File manager (Oil)
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>-", "<CMD>Oil --float<CR>", { desc = "Open Oil in floating window" })

-- Search and navigation improvements
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Window navigation without <C-w>
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Focus window left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Focus window below" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Focus window above" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Focus window right" })

-- Move selected lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })

-- Paste in visual mode without overwriting register
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })


