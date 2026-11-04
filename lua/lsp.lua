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

