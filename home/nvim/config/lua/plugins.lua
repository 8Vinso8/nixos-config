require("catppuccin").setup({
  flavour = "mocha",
  integrations = {
    treesitter = true,
    telescope = true,
    mini = true,
    which_key = true,
    blink_cmp = true,
    gitsigns = true,
  },
})
vim.cmd.colorscheme "catppuccin-nvim"

require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()

require("oil").setup({
  view_options = {
    show_hidden = true,
  },
})

require("telescope").setup({
  defaults = {
    file_ignore_patterns = { "%.git/", "node_modules/" },
    vimgrep_arguments = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--hidden" },
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
  },
})
require("telescope").load_extension("fzf")

require("lualine").setup({
  options = {
    theme = "catppuccin-nvim",
    globalstatus = true,
  },
})

require("lazydev").setup()

require("nvim-autopairs").setup({
  check_ts = true,
})

require("which-key").setup({
  preset = "modern",
})
require("which-key").add({
  { "<leader>f", group = "Find" },
  { "<leader>d", group = "Document" },
  { "<leader>h", group = "Git hunk" },
})

require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("n", "]h", function() gs.nav_hunk("next") end, "Next git hunk")
    map("n", "[h", function() gs.nav_hunk("prev") end, "Previous git hunk")
    map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
    map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
    map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
  end,
})

require("blink.cmp").setup({
  keymap = { preset = "enter" },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "mono",
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  completion = {
    list = {
      selection = {
        preselect = false,
        auto_insert = false,
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = { border = "rounded" },
    },
    menu = {
      border = "rounded",
    },
  },
  signature = {
    enabled = true,
    window = { border = "rounded" },
  },
})
