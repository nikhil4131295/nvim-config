local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
  defaults = {
    file_ignore_patterns = {
      "Library/",
      "%.git/",
      "node_modules/",
      "%.o",
      "%.a",
      "%.dylib",
      "%.out",
      "build/",
    },
    find_command = { 
      "fd", 
      "--type", "f", 
      "--strip-cwd-prefix", 
      "--hidden", 
      "--exclude", "Library", 
      "--exclude", ".git" 
    },
  },
})

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find Text (Grep)" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help" })
