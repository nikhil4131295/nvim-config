-- 1. Setup Catppuccin
require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = false,
  term_colors = true,
})
vim.cmd.colorscheme("moonfly")

-- 2. Setup Lualine using Catppuccin's explicit theme name
require("lualine").setup({
  options = {
    theme = 'auto',
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

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Split a single multiline string into a table of lines automatically
local raw_ascii = [==========[
                                                                           
	  ██████   █████                   █████   █████  ███                  
	 ::██████ ::███                   ::███   ::███  :::                   
	  :███:███ :███   ██████   ██████  :███    :███  ████  █████████████   
	  :███::███:███  ███::███ ███::███ :███    :███ ::███ ::███::███::███  
	  :███ ::██████ :███████ :███ :███ ::███   ███   :███  :███ :███ :███  
	  :███  ::█████ :███:::  :███ :███  :::█████:    :███  :███ :███ :███  
	  █████  ::█████::██████ ::██████     ::███      █████ █████:███ █████ 
	 :::::    :::::  ::::::   ::::::       :::      ::::: ::::: ::: :::::  
	                                                                       
]==========]


dashboard.section.header.val = vim.split(raw_ascii, "\n", { trimempty = true })

-- Set dashboard menu buttons
dashboard.section.buttons.val = {
  dashboard.button("e", "  > New file"   , ":ene <BAR> startinsert <CR>"),
  dashboard.button("f", "  > Find file"  , ":Telescope find_files<CR>"),
  dashboard.button("r", "  > Recent files", ":Telescope oldfiles<CR>"),
  dashboard.button("s", "⚙  > Settings"    , ":e $MYVIMRC<CR>"),
  dashboard.button("q", "  > Quit NVIM"   , ":qa<CR>"),
}

alpha.setup(dashboard.opts)
