--------------------------------------------------------------------------------
--- lspconfig.lua
--------------------------------------------------------------------------------
require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "gopls", "clangd" }
vim.lsp.enable(servers)

vim.lsp.config('*', {
  root_markers = { '.git', '.hg' },
})

vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      }
    }
  }
})




-- read :h vim.lsp.config for changing options of lsp servers
