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
-- Font-Cycle setup

if vim.g.neovide then
    -- Back to JetBrains Mono with Nerd Font support
    vim.o.guifont = "JetBrainsMono Nerd Font:h18"
    -- Remove vertical gaps between block characters
    vim.g.neovide_linespace = 0
    -- macOS shortcuts & input settings
    vim.g.neovide_input_ime = false
    vim.g.neovide_input_use_logo = true
           -- Breathing room around the text
       vim.g.neovide_padding_top = 10
       vim.g.neovide_padding_bottom = 10
       vim.g.neovide_padding_left = 12
       vim.g.neovide_padding_right = 12
       -- Slightly snappier smooth scrolling (default is 0.3)
       vim.g.neovide_scroll_animation_length = 0.25
       -- Hide the mouse pointer while typing
       vim.g.neovide_hide_mouse_when_typing = true
              -- Subtle see-through window with blur behind it (1.0 = fully solid)
       vim.g.neovide_opacity = 0.70
       vim.g.neovide_window_blurred = true
              -- Fullscreen that keeps transparency and blur (hides Dock and menu bar)
       vim.g.neovide_macos_simple_fullscreen = false
       vim.keymap.set("n", "<leader>tf", function()
           vim.g.neovide_macos_simple_fullscreen = not vim.g.neovide_macos_simple_fullscreen
       end, { desc = "Toggle simple fullscreen (keeps blur)" })
              -- Thin line cursor normally; thick block only while moving (keeps the smear chunky)
       local cursor_thin  = "n-v-c-sm:ver20,i-ci-ve:ver25,r-cr-o:hor20"
       local cursor_thick = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
       local cursor_timer = vim.uv.new_timer()
       vim.o.guicursor = cursor_thin
       vim.api.nvim_create_autocmd("CursorMoved", {
           callback = function()
               if vim.o.guicursor ~= cursor_thick then
                   vim.o.guicursor = cursor_thick
               end
               cursor_timer:stop()
               cursor_timer:start(300, 0, vim.schedule_wrap(function()
                   vim.o.guicursor = cursor_thin
               end))
           end,
       })
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


   -- Adjustable background opacity: Space Cmd + ] / Cmd + [ (remembered between restarts)
   if vim.g.neovide then
     local opacity_file = vim.fn.stdpath("state") .. "/neovide_opacity"
     local function load_opacity()
       local ok, lines = pcall(vim.fn.readfile, opacity_file)
       return (ok and tonumber(lines[1])) or 0.95
     end
     local function set_opacity(v)
            v = math.max(0.2, math.min(0.99, math.floor(v * 100 + 0.5) / 100))
       vim.g.neovide_normal_opacity = v
       pcall(vim.fn.writefile, { tostring(v) }, opacity_file)
       vim.notify(string.format("Background opacity: %.2f", v), vim.log.levels.INFO, { title = "Neovide" })
     end

     vim.g.neovide_normal_opacity = load_opacity()
          vim.keymap.set("n", "<D-]>", function() set_opacity(vim.g.neovide_normal_opacity + 0.02) end,
       { desc = "More opaque background (Cmd+])" })
     vim.keymap.set("n", "<D-[>", function() set_opacity(vim.g.neovide_normal_opacity - 0.02) end,
       { desc = "More transparent background (Cmd+[)" })
     vim.keymap.set("n", "<leader>b0", function() set_opacity(0.95) end, { desc = "Reset background opacity" })
   end
