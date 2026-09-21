print("configs.lspconfig loaded")

local servers = { "html",
                  "cssls",
                  "gopls",
                  "clangd",
                  "elixirls",
                  "pyright",
                  "cmake",
                  "bashls",
                  "lua_ls",
                }

vim.lsp.config("gopls", {})
vim.lsp.config("pyright", {})
vim.lsp.config("cmake", {})
vim.lsp.config("bashls", {})
vim.lsp.config("html", {})
vim.lsp.config("cssls", {})
vim.lsp.config("lua_ls", {})

vim.lsp.config("lua_ls", {
  before_init = function(_, config)
    config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },

        runtime = {
          version = "LuaJIT",
        },

        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            vim.fn.stdpath("config"),
          },
        },

        telemetry = {
          enable = false,
        },
      },
    })
  end,
})

--[[vim.lsp.config("lua_ls", {
   Lua = {
      diagnostics = {
        globals = { "vim" },
      },

      runtime = {
        version = "LuaJIT",
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
      telemetry = {
        enable = false,
      },
    },
})
]]

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

vim.lsp.config("elixirls", {
  cmd = { "/home/gordonyx/.local/bin/elixir-ls/release/language_server.sh" },
  root_markers = { "mix.exs", ".git" },
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
        [vim.diagnostic.severity.ERROR] = "E ",
        [vim.diagnostic.severity.WARN] = "W ",
        [vim.diagnostic.severity.HINT] = "H ",
        [vim.diagnostic.severity.INFO] = "I ",
      }
    }
  }
)







--[[local servers = { "lua-language-server",
                  "html-lsp",
                  "css-lsp",
                  "gopls",
                  "clangd",
                  "elixirls",
                  "pyright",
                  "cmake-language-server",
                  "bash-language-server" 
                }

vim.lsp.config("gopls", {})
vim.lsp.config("pyright", {})
vim.lsp.config("lua-language-server", {})
--vim.lsp.config("cmake-language-server", {})
--vim.lsp.config("bash-language-server", {})
--vim.lsp.config("html-lsp", {})
--vim.lsp.config("css-lsp", {})


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

vim.lsp.config("elixirls", {
  cmd = { "/home/gordonyx/.local/bin/elixir-ls/release/language_server.sh" },
  root_markers = { "mix.exs", ".git" },
})

vim.lsp.enable(servers)

vim.diagnostic.config(
  {
    underline = false,
    virtual_text = false,
    update_in_insert = false,
    severity_sort = true,
    --[[signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
      }
    }

    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "E ",
        [vim.diagnostic.severity.WARN] = "W ",
        [vim.diagnostic.severity.HINT] = "H ",
        [vim.diagnostic.severity.INFO] = "I ",
      }
    }

  }
)
]]
