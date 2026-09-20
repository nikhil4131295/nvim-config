vim.g.mapleader = " "

vim.keymap.set("x", "p", [["_dP]], { desc = "Paste over selection without losing yanked text" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "<C-c>", ":nohl<CR>", { desc = "Clear search highlighting", silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

vim.keymap.set("v", "<", "<gv", { desc = "Unindent and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "move down in buffer with cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "move up in buffer with cursor centered" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result cursor centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result cursor centered" })

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word cursor is on globally" })
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "makes file executable" })

vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>", { desc = "Restart config :restart)" })

-- native undotree
vim.keymap.set("n", "<leader>u", function()
    vim.cmd.packadd("nvim.undotree")
    require("undotree").open()
end, { desc = "Toggle Builtin Undotree" })

-- Compile and Run C++ code on <F5>
vim.keymap.set("n", "<leader>r", function()
  -- Save the current file first
  vim.cmd("w")

  local file = vim.fn.expand("%")
  local output = vim.fn.expand("%:r")

  -- Check if a terminal buffer already exists and wipe it to clean previous outputs
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end

  -- Open a vertical split on the far right and start the compile & run command
  vim.cmd("botright vsplit | terminal g++ -std=c++17 " .. vim.fn.shellescape(file) .. " -o " .. vim.fn.shellescape(output) .. " && ./" .. vim.fn.shellescape(output))
  
  -- Optionally adjust terminal width (e.g., 50 columns wide)
  vim.cmd("vertical resize 50")
  
  -- Enter insert mode automatically so you can type cin inputs right away
  vim.cmd("startinsert")
end, { desc = "Compile and Run C++ in Right Terminal Split" })

-- Clear search highlights with <Esc>
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true, desc = "Clear search highlights" })

-- Fast theme switcher: Press <leader>th to instantly swap to the next theme
local favorite_themes = {
  "catppuccin-mocha",
  "moonfly",
  "gruvbox",
  "tokyonight-night",
  "tokyonight-storm",
  "monokai",
}
local current_theme_index = 1

vim.keymap.set("n", "<leader>th", function()
  current_theme_index = (current_theme_index % #favorite_themes) + 1
  local theme = favorite_themes[current_theme_index]
  vim.cmd.colorscheme(theme)
  vim.notify("Theme: " .. theme, vim.log.levels.INFO, { title = "Colorscheme Switched" })
end, { desc = "Cycle through favorite themes instantly" })

-- Move single lines up/down with Alt/Option + j/k or Up/Down
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("n", "<A-Down>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-Up>", "<cmd>m .-2<CR>==", { desc = "Move line up" })

-- Move highlighted blocks of code up/down in Visual Mode
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })


-- Word movement in Insert Mode
vim.keymap.set("i", "<A-Left>", "<C-o>b", { desc = "Move back one word" })
vim.keymap.set("i", "<A-Right>", "<C-o>w", { desc = "Move forward one word" })

-- Jump to start/end of line in Normal & Insert modes
vim.keymap.set({ "n", "i" }, "<D-Left>", "<Home>", { desc = "Jump to start of line" })
vim.keymap.set({ "n", "i" }, "<D-Right>", "<End>", { desc = "Jump to end of line" })

-------------------------------------------------------------------------------
-- 1. Word Hopping with Option + Left / Right (behaves like 'b' and 'w')
-------------------------------------------------------------------------------
-- Normal mode word jumping
vim.keymap.set("n", "<A-Left>", "b", { desc = "Jump word backward" })
vim.keymap.set("n", "<A-Right>", "w", { desc = "Jump word forward" })

-- Insert mode word jumping
vim.keymap.set("i", "<A-Left>", "<C-o>b", { desc = "Jump word backward" })
vim.keymap.set("i", "<A-Right>", "<C-o>w", { desc = "Jump word forward" })

-------------------------------------------------------------------------------
-- 2. Shift + Arrows Selection (VS Code Style)
-------------------------------------------------------------------------------
-- Shift + Left/Right character selection in Normal Mode
vim.keymap.set("n", "<S-Left>", "vC-h>", { desc = "Select left" })
vim.keymap.set("n", "<S-Right>", "v", { desc = "Select right" })

-- Shift + Up/Down line selection in Normal Mode
vim.keymap.set("n", "<S-Up>", "Vk", { desc = "Select line up" })
vim.keymap.set("n", "<S-Down>", "Vj", { desc = "Select line down" })

-- Continue expanding selection while in Visual Mode
vim.keymap.set("v", "<S-Left>", "h", { desc = "Expand selection left" })
vim.keymap.set("v", "<S-Right>", "l", { desc = "Expand selection right" })
vim.keymap.set("v", "<S-Up>", "k", { desc = "Expand selection up" })
vim.keymap.set("v", "<S-Down>", "j", { desc = "Expand selection down" })

-- Shift + Option + Left/Right (Word-by-word selection)
vim.keymap.set("n", "<S-A-Left>", "vb", { desc = "Select word left" })
vim.keymap.set("n", "<S-A-Right>", "vw", { desc = "Select word right" })
vim.keymap.set("v", "<S-A-Left>", "b", { desc = "Expand word selection left" })
vim.keymap.set("v", "<S-A-Right>", "w", { desc = "Expand word selection right" })
