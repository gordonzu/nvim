require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "gopls", }
vim.lsp.enable(servers)

vim.lsp.config("gopls", {})
vim.lsp.config("html", {})
vim.lsp.config("cssls", {})

vim.diagnostic.config(
  {
    underline = false,
    virtual_text = false,
    update_in_insert = false,
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
      }
    }
  }
)

-- read :h vim.lsp.config for changing options of lsp servers 
