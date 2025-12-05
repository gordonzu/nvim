--------------------------------------------------------------------------------
--- lspconfig.lua
--------------------------------------------------------------------------------
require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "gopls", "clangd", "pyright" }
vim.lsp.enable(servers)

vim.lsp.config("*", {
  root_markers = { ".git", ".hg" },
})

vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  },
})

vim.lsp.config("roslyn", {})

-- read :h vim.lsp.config for changing options of lsp servers
