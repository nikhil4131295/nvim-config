-- Set initial scale factor if not already defined
if vim.g.neovide_scale_factor == nil then
  vim.g.neovide_scale_factor = 1.0
end

-- Function to adjust scale factor safely
local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

-- Keymaps for zooming in, out, and resetting (Cmd + +, Cmd + -, Cmd + 0)
vim.keymap.set({ "n", "v", "i" }, "<D-+>", function()
  change_scale_factor(1.15)
end, { desc = "Zoom In" })

vim.keymap.set({ "n", "v", "i" }, "<D-=>", function()
  change_scale_factor(1.15)
end, { desc = "Zoom In (Equal key)" })

vim.keymap.set({ "n", "v", "i" }, "<D-->", function()
  change_scale_factor(1 / 1.15)
end, { desc = "Zoom Out" })

vim.keymap.set({ "n", "v", "i" }, "<D-0>", function()
  vim.g.neovide_scale_factor = 1.0
end, { desc = "Reset Zoom" })


-------------------------------------------------------------------------------
-- Neovide GUI Settings
-------------------------------------------------------------------------------
if vim.g.neovide then
  -- Back to JetBrains Mono with Nerd Font support
  vim.o.guifont = "JetBrainsMono Nerd Font:h18"

  -- Remove vertical gaps between block characters
  vim.g.neovide_linespace = 0

  -- macOS shortcuts & input settings
  vim.g.neovide_input_ime = false
  vim.g.neovide_input_use_logo = true
end

-- Font-Cycle setup


if vim.g.neovide then
    -- Back to JetBrains Mono with Nerd Font support
    vim.o.guifont = "JetBrainsMono Nerd Font:h18"
    -- Remove vertical gaps between block characters
    vim.g.neovide_linespace = 0
    -- macOS shortcuts & input settings
    vim.g.neovide_input_ime = false
    vim.g.neovide_input_use_logo = true
end

local fonts = {
  "JetBrainsMono Nerd Font:h18",
  "FiraCode Nerd Font:h18",
  "Menlo:h18",
  "Hack Nerd Font:h18"
}

local current_font_index = 1

local function cycle_font()
  current_font_index = (current_font_index % #fonts) + 1
  local new_font = fonts[current_font_index]
  vim.o.guifont = new_font
  vim.notify("Font set to: " .. new_font, vim.log.levels.INFO)
end

vim.keymap.set("n", "<space>fc", cycle_font, { desc = "Cycle Neovide fonts" })
