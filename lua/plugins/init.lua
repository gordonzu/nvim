return {

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

  {
    "stevearc/conform.nvim",
    event = 'BufWritePre',
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },
  {
  	"nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
      "vim",
      "lua",
      "vimdoc",
      "html",
      "css",
      "go",
      "bash",
      "elixir",
      "heex",
      "eex",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    },

    config = function(_, opts)
      vim.treesitter.language.register("bash", "conf")
      vim.treesitter.language.register("bash", "kitty")
      vim.treesitter.language.register("bash", "tmux")
      vim.treesitter.language.register("bash", "sh")
    end,
  },

  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup {
        default_file_explorer = true,
        restore_win_options = true,
        skip_confirm_for_simple_edits = true,

        float = {
          padding = 2,
          max_width = 80,
          max_height = 35,
          border = "rounded",
          win_options = {
            winblend = 0,
          }
        },

        override = function(conf)
          conf.row = 1
          return conf
        end,

        view_options = {
          show_hidden = true,
          is_hidden_file = function(name)
            return false
          end,
          natural_order = true,
          sort = {
            { "type", "asc" },
            { "name", "asc" },
          },
        },

        columns = {
          "icon",
          "permissions",
          "size",
          "mtime",
        },
      }
    end,
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function() require("configs.tiny-inline-diagnostic") end
  },


}
