
local opts = {
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

require("oil").setup(opts)

--vim.api.nvim_command("Oil")

vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "oil.nvim" })

return {}








