-- Enable Auto-pairs
require("nvim-autopairs").setup({})

-- Safely load Comment if present, otherwise ignore
local status, comment = pcall(require, "Comment")
if status then
  comment.setup()
end
