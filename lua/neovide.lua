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
  -- Disable IME composition lag
  vim.g.neovide_input_ime = false

  -- Enable macOS Command key shortcuts (<D-a>, <D-c>, <D-v>) natively
  vim.g.neovide_input_use_logo = true
end
