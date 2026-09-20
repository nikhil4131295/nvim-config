vim.pack.add({
    "https://github.com/bluz71/vim-moonfly-colors",
    "https://github.com/rafamadriz/friendly-snippets",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/jiaoshijie/undotree",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/goolord/alpha-nvim",
    "https://github.com/catppuccin/nvim",
    "https://github.com/ellisonleao/gruvbox.nvim",
    "https://github.com/folke/tokyonight.nvim", -- TokyoNight
    "https://github.com/tanvirtin/monokai.nvim", -- Monokai Pro / Classic
    --"https://github.com/stevearc/oil.nvim",
    "https://github.com/nvim-tree/nvim-tree.lua",
    "https://github.com/echasnovski/mini.nvim",
    "https://github.com/windwp/nvim-autopairs",
    "https://github.com/numToStr/Comment.nvim",
    "https://github.com/akinsho/bufferline.nvim",
})

---- nvim-tree file explorer sidebar ----
require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
        side = "left",
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
})

-- Toggle Sidebar with <leader>e
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree Sidebar" })
-----------------------------------------------


require("mini.notify").setup({
    -- only show messages
    content = {
        format = function(notif)
            return notif.msg
        end,
    },
})

--- mini cmdline completion ---
require("mini.cmdline").setup({
    autocorrect = { enable = false }
})

--- mini surround ---
require("mini.surround").setup()
-- Default Keymaps
-- | `sa` | Add surrounding or Direct with 'saiw' |
-- | `sd` | Delete surrounding |
-- | `sr` | Replace surrounding |
-- | `sf` | Find surrounding (right) |
-- | `sF` | Find surrounding (left) |
-- | `sh` | Highlight surrounding |
-- | `sn` | Update n_lines |
-- | `l` / `n` | as suffix for prev/next |

--- mini picker ---
local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")
MiniPick.setup()
MiniExtra.setup()

-- keymaps
vim.keymap.set("n", "<leader>pf", function() MiniPick.builtin.files() end, { desc = "Mini File Picker" })
vim.keymap.set("n", "<leader>ps", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end,
    { desc = "Grep word/Search word" })
vim.keymap.set("n", "<leader>vh", function() MiniPick.builtin.help() end, { desc = "Mini Help" })

vim.keymap.set("n", "<leader>xx", function() MiniExtra.pickers.diagnostic() end, { desc = "Mini Picker Diagnostics" })
vim.keymap.set("n", "<leader>pk", function() MiniExtra.pickers.keymaps() end, { desc = 'Search keymaps' })

--- mini completions ---
require("mini.completion").setup({
    lsp_completion = {
        auto_setup = true,
    }
})

--- mini snippets ---
local MiniSnippets = require("mini.snippets")
MiniSnippets.setup({
    snippets = {
        MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets
    },
})
MiniSnippets.start_lsp_server({ match = false })

--- mini diff and fugitive ---
local MiniDiff = require("mini.diff")
MiniDiff.setup({
    source = MiniDiff.gen_source.git({ index = false }),
})

vim.keymap.set("n", "<leader>gg", "<cmd>tabnew | Git | only<cr>", { desc = "Fugitive Full Page New Tab" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split", })

-------------------------------------------------------------------------------
-- Treesitter Configuration (Rich Syntax Highlighting)
-------------------------------------------------------------------------------
-- Treesitter Configuration (Safe Load)
local status, treesitter = pcall(require, "nvim-treesitter.configs")
if status then
  treesitter.setup({
    ensure_installed = { "java", "cpp", "c", "lua", "vim", "vimdoc" },
    highlight = {
      enable = true, -- Enables rich AST-based colors
    },
  })
end

-------------------------------------------------------------------------------
-- Alpha Startup Dashboard Configuration
-------------------------------------------------------------------------------
local status, alpha = pcall(require, "alpha")
if status then
  local dashboard = require("alpha.themes.dashboard")
  
  -- Custom ASCII Art Header
  dashboard.section.header.val = {
    "                                                     ",
    "  ███╗   ██╗███████╗██╗   ██╗██╗███╗   ███╗          ",
    "  ████╗  ██║██╔════╝██║   ██║██║████╗ ████║          ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║██╔████╔██║          ",
    "  ██║╚██╗██║██╔══╝  ╚██╗ ██╔╝██║██║╚██╔╝██║          ",
    "  ██║ ╚████║███████╗ ╚████╔╝ ██║██║ ╚═╝ ██║          ",
    "  ╚═╝  ╚═══╝╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝          ",
    "                                                     ",
  }

  -- Quick Action Buttons
  dashboard.section.buttons.val = {
    dashboard.button("f", "🔍  Find file", "<cmd>MiniPickBuiltin files<CR>"),
    dashboard.button("e", "📂  New file", "<cmd>ene <BAR> startinsert <CR>"),
    dashboard.button("r", "🕒  Recent files", "<cmd>MiniPickBuiltin oldfiles<CR>"),
    dashboard.button("q", "❌  Quit Neovim", "<cmd>qa<CR>"),
  }

  alpha.setup(dashboard.opts)
end

require("treesitter")

require("lsp")
