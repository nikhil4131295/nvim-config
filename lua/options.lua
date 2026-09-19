local opt = vim.opt

vim.g.netrw_banner = 0;

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & Indentation (4 spaces for C++)
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

opt.wrap = false
opt.smartindent = true
opt.inccommand = "split"

-- Search & Appearance
opt.showmode = true
opt.smartcase = true
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.colorcolumn = "0"
opt.cursorline = true
opt.scrolloff = 8

-- Split Directions
opt.splitbelow = true
opt.splitright = true

-- Clipboard & Mouse
opt.clipboard = "unnamedplus"
opt.mouse = "a"

-- Others
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.undofile = true

vim.opt.completeopt = "menuone,noselect,fuzzy,nosort"
vim.opt.clipboard = vim.opt.clipboard + "unnamedplus"
opt.isfname:append("@-@")
opt.guicursor = ""
opt.cmdheight = 1

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    callback = function()
        vim.hl.on_yank()
    end,
})



