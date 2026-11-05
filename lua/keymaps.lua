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

--    -- Multi-Language Smart Code Runner (C++ via /tmp & Java)
   local runner_term_buf = nil

   local function open_run_panel(cmd)
     -- Close only the previous runner terminal (not other terminals)
     if runner_term_buf and vim.api.nvim_buf_is_valid(runner_term_buf) then
       vim.api.nvim_buf_delete(runner_term_buf, { force = true })
     end
     local height = math.max(10, math.floor(vim.o.lines * 0.35))
     vim.cmd(string.format("botright %dsplit | terminal %s", height, cmd))
     vim.wo.winfixheight = true
     vim.cmd("startinsert")
     runner_term_buf = vim.api.nvim_get_current_buf()
   end

   -- How Neovim reads g++ error lines (file:line:col: error: message)
   local gcc_efm = table.concat({
     "%f:%l:%c: fatal error: %m",
     "%f:%l:%c: %trror: %m",
     "%f:%l:%c: %tarning: %m",
     "%f:%l:%c: note: %m",
   }, ",")

   vim.keymap.set("n", "<leader>r", function()
     -- Save file first if it's modified and has a valid filename
     if vim.bo.modified and vim.api.nvim_buf_get_name(0) ~= "" then
       vim.cmd("w")
     end

     local ft = vim.bo.filetype
     local file = vim.fn.expand("%:p")
     local name = vim.fn.expand("%:t:r")
     local tmp_bin = "/tmp/" .. name

     if ft == "cpp" then
       vim.cmd("cclose")
       local ok, err = pcall(vim.system, {
         "g++", "-std=c++17", "-fdiagnostics-color=never", file, "-o", tmp_bin,
       }, { text = true }, function(res)
         vim.schedule(function()
           if res.code == 0 then
             open_run_panel(string.format("%s && rm %s",
               vim.fn.shellescape(tmp_bin), vim.fn.shellescape(tmp_bin)))
           else
             vim.fn.setqflist({}, " ", {
               title = "g++ errors",
               lines = vim.split(res.stderr or "", "\n"),
               efm = gcc_efm,
             })
             vim.cmd("botright copen 10")
             pcall(vim.cmd, "cfirst")
           end
         end)
       end)
       if not ok then
         vim.notify("Could not start g++: " .. tostring(err), vim.log.levels.ERROR)
       end
     elseif ft == "java" then
       open_run_panel("java " .. vim.fn.shellescape(file))
     else
       vim.notify("No runner configured for filetype: " .. ft, vim.log.levels.WARN)
     end
   end, { desc = "Compile & Run C++ (errors to quickfix) or Java" })

   -- Press q to close the quickfix error list
   vim.api.nvim_create_autocmd("FileType", {
     pattern = "qf",
     callback = function(args)
       vim.keymap.set("n", "q", "<cmd>cclose<CR>", { buffer = args.buf, desc = "Close error list" })
     end,
   })

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
  "pinkish_day",
  "gruber-darker"
}
   vim.keymap.set("n", "<leader>th", function()
     -- Continue from whichever theme is active right now
     local idx = 0
     for i, t in ipairs(favorite_themes) do
       if t == vim.g.colors_name then
         idx = i
         break
       end
     end
     local theme = favorite_themes[(idx % #favorite_themes) + 1]
     vim.cmd.colorscheme(theme)
     -- Remember the choice for next startup
     pcall(vim.fn.writefile, { theme }, vim.fn.stdpath("state") .. "/last_theme")
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
vim.keymap.set("n", "<S-Left>", "vh", { desc = "Select left" })
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


-------------------------------------------------------------------------------
-- Terminal Navigation & Exit Helper Shortcuts
-------------------------------------------------------------------------------
-- Press <Esc><Esc> inside terminal to exit Terminal Insert mode immediately
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Easy window navigation directly from terminal mode
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left window from terminal" })
vim.keymap.set("t", "<C-q>", "<C-\\><C-n><cmd>close<CR>", { desc = "Close terminal split" })

-------------------------------------------------------------------------------
-- Universal Smart Formatting Override (<Space>f)
-------------------------------------------------------------------------------
local function smart_format()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local has_lsp_formatter = false

  for _, client in ipairs(clients) do
    -- Use colon syntax client:supports_method to prevent deprecation warnings
    if client:supports_method("textDocument/formatting") then
      has_lsp_formatter = true
      break
    end
  end

  if has_lsp_formatter then
    vim.lsp.buf.format({ async = true })
  else
    local view = vim.fn.winsaveview()
    vim.cmd("normal! gg=G")
    vim.fn.winrestview(view)
    vim.notify("Formatted using native indent rules", vim.log.levels.INFO)
  end
end

-- Set globally
vim.keymap.set("n", "<leader>f", smart_format, { desc = "Smart Code Formatter" })

-- Force override buffer-local mappings set by mini.extra or LSP plugins
vim.api.nvim_create_autocmd({ "FileType", "LspAttach" }, {
  callback = function(args)
    vim.keymap.set("n", "<leader>f", smart_format, { buffer = args.buf, desc = "Smart Code Formatter" })
  end,
})

-------------------------------------------------------------------------------
-- Option + Shift + Up/Down Line Scrolling (Jumps 7 lines)
-------------------------------------------------------------------------------
-- Normal mode: Jump cursor 7 lines up/down
vim.keymap.set("n", "<M-S-Up>", "7k", { desc = "Scroll cursor up 7 lines" })
vim.keymap.set("n", "<M-S-Down>", "7j", { desc = "Scroll cursor down 7 lines" })

-- Visual mode: Extend text selection by 7 lines
vim.keymap.set("v", "<M-S-Up>", "7k", { desc = "Extend selection up 7 lines" })
vim.keymap.set("v", "<M-S-Down>", "7j", { desc = "Extend selection down 7 lines" })

-- Insert mode: Jump cursor 7 lines without outputting escape artifacts (-h>)
vim.keymap.set("i", "<M-S-Up>", "<C-o>7k", { desc = "Scroll cursor up 7 lines in insert mode" })
vim.keymap.set("i", "<M-S-Down>", "<C-o>7j", { desc = "Scroll cursor down 7 lines in insert mode" })


-------------------------------------------------------------------------------
-- Native Code Commenting (<Cmd+/> and <Ctrl+/>)
-------------------------------------------------------------------------------
-- Normal mode (Uses native 'gcc' operator)
vim.keymap.set("n", "<D-/>", "gcc", { remap = true, desc = "Toggle comment line" })
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment line" })
vim.keymap.set("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment line" })

-- Insert mode (Escapes briefly to run gcc, then returns to insert mode)
vim.keymap.set("i", "<D-/>", "<Esc>gccgi", { remap = true, desc = "Toggle comment line" })
vim.keymap.set("i", "<C-/>", "<Esc>gccgi", { remap = true, desc = "Toggle comment line" })
vim.keymap.set("i", "<C-_>", "<Esc>gccgi", { remap = true, desc = "Toggle comment line" })

-- Visual mode (Uses native 'gc' operator)
vim.keymap.set("v", "<D-/>", "gc", { remap = true, desc = "Toggle comment selection" })
vim.keymap.set("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment selection" })
vim.keymap.set("v", "<C-_>", "gc", { remap = true, desc = "Toggle comment selection" })


-------------------------------------------------------------------------------
-- Select All (Cmd + A) across Normal, Visual, and Insert Modes
-------------------------------------------------------------------------------
vim.keymap.set("n", "<D-a>", "ggVG", { desc = "Select all text" })
vim.keymap.set("v", "<D-a>", "<Esc>ggVG", { desc = "Select all text" })
vim.keymap.set("i", "<D-a>", "<Esc>ggVG", { desc = "Select all text" })


-------------------------------------------------------------------------------
-- macOS Clipboard Operations (Cmd + C / Cmd + V)
-------------------------------------------------------------------------------
-- Copy selected text in Visual mode
vim.keymap.set("v", "<D-c>", '"+y', { desc = "Copy to system clipboard" })

-- Paste system clipboard in Normal and Visual mode
vim.keymap.set({"n", "v"}, "<D-v>", '"+p', { desc = "Paste from system clipboard" })

-- Paste system clipboard in Insert mode
vim.keymap.set("i", "<D-v>", "<C-r>+", { desc = "Paste from system clipboard in insert mode" })

-- Paste from system clipboard in Command-line mode
vim.keymap.set("c", "<D-v>", "<C-r>+", { desc = "Paste from system clipboard in command mode" })


-------------------------------------------------------------------------------
-- Undo & Redo (Cmd + Z / Cmd + Shift + Z) across Normal, Visual, and Insert Modes
-------------------------------------------------------------------------------
-- Normal & Visual Mode
vim.keymap.set({"n", "v"}, "<D-z>", "u", { desc = "Undo change" })
vim.keymap.set({"n", "v"}, "<D-Z>", "<C-r>", { desc = "Redo change" })

-- Insert Mode (temporarily escapes to execute undo/redo without dropping out of insert mode)
vim.keymap.set("i", "<D-z>", "<C-o>u", { desc = "Undo change in insert mode" })
vim.keymap.set("i", "<D-Z>", "<C-o><C-r>", { desc = "Redo change in insert mode" })

   -- Terminal panel: ignore mouse clicks while typing (prevents accidental focus loss)
   for _, key in ipairs({ "<LeftMouse>", "<LeftDrag>", "<LeftRelease>", "<2-LeftMouse>" }) do
     vim.keymap.set("t", key, "<Nop>", { desc = "Ignore mouse in terminal mode" })
   end

   -- Move up from the bottom panel back to your code
   vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move to window above from terminal" })

   local term_group = vim.api.nvim_create_augroup("TerminalPanel", { clear = true })

   -- Clean look and handy keys for every terminal buffer
   vim.api.nvim_create_autocmd("TermOpen", {
     group = term_group,
     callback = function(args)
       vim.wo.number = false
       vim.wo.relativenumber = false
       vim.wo.signcolumn = "no"
       vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf, desc = "Close terminal" })
     end,
   })

   -- Entering a terminal window puts you straight into typing mode
   vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
     group = term_group,
     pattern = "term://*",
     command = "startinsert",
   })
