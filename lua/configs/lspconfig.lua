require("nvchad.configs.lspconfig").defaults()

local servers = { "html-lsp",
                  "css-lsp",
                  "gopls",
                  "clangd",
                  "pyright",
                  "cmake-language-server",
                  "bash-language-server" }

vim.lsp.config("gopls", {})
vim.lsp.config("pyright", {})
vim.lsp.config("cmake-language-server", {})
vim.lsp.config("bash-language-server", {})
vim.lsp.config("html-lsp", {})
vim.lsp.config("css-lsp", {})


vim.lsp.config("clangd", {
  cmd = {
    "/home/gordonyx/.local/bin/llvm/bin/clangd",
    "--log=verbose",
    "--pretty",
    "--enable-config",
    "--background-index",
    "--compile-commands-dir=build",
    "--query-driver=/home/gordonyx/.local/bin/llvm/bin/clang++",
  },
})

vim.lsp.enable(servers)

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
