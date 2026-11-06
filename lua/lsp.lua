require("mason").setup()

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

   vim.diagnostic.config({
     virtual_text = { prefix = "●", spacing = 2 },
     signs = {
       text = {
         [vim.diagnostic.severity.ERROR] = "\u{f057}",
         [vim.diagnostic.severity.WARN]  = "\u{f071}",
         [vim.diagnostic.severity.INFO]  = "\u{f05a}",
         [vim.diagnostic.severity.HINT]  = "\u{f0eb}",
       },
     },
     severity_sort = true,
     float = { source = "if_many" },
   })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())

vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
        },
    },
})

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
  },
})

vim.lsp.enable({
    "clangd",
    "lua_ls",
    "marksman",
    "gopls",
    "rust_analyzer",
})


   -- Show "Expected ..." errors on the line where the token is missing
   -- (end of the previous non-blank line) instead of the next line.
   local original_diag_set = vim.diagnostic.set
   vim.diagnostic.set = function(namespace, bufnr, diagnostics, opts)
     if diagnostics then
       for _, d in ipairs(diagnostics) do
         if d.message and d.message:match("^Expected") and d.lnum and d.lnum > 0 then
           pcall(function()
             local prev = d.lnum - 1
             while prev >= 0 do
               local line = vim.api.nvim_buf_get_lines(bufnr, prev, prev + 1, false)[1] or ""
               if line:match("%S") then break end
               prev = prev - 1
             end
             if prev >= 0 then
               local text = vim.api.nvim_buf_get_lines(bufnr, prev, prev + 1, false)[1] or ""
               local len = #text:gsub("%s+$", "")
               d.lnum, d.end_lnum = prev, prev
               d.col, d.end_col = len, len
             end
           end)
         end
       end
     end
     return original_diag_set(namespace, bufnr, diagnostics, opts)
   end
