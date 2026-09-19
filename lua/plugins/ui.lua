-- 1. Setup Catppuccin
require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = false,
  term_colors = true,
})
vim.cmd.colorscheme("catppuccin")

-- 2. Setup Lualine using Catppuccin's explicit theme name
require("lualine").setup({
  options = {
    theme = "catppuccin-mocha", -- Explicit lualine theme provided by catppuccin
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
    globalstatus = true,
  },
})

-- Setup Bufferline (Browser-like tabs at the top)
require("bufferline").setup({
  options = {
    mode = "buffers",
    diagnostics = "nvim_lsp",
    always_show_bufferline = true,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left",
        separator = true,
      },
    },
  },
})

-- Keymaps to cycle between tabs using Shift + h / Shift + l
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous tab/buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next tab/buffer" })

-- Keymap to close the current tab buffer using <leader>x
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close current tab/buffer" })
