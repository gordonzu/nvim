require "nvchad.options"

-- add yours here!

-- Global map wrapper: allows passing a string as the 4th argument for the desc
_G.map = function(mode, lhs, rhs, opts)
  if type(opts) == "string" then
    opts = { desc = opts }
  elseif opts == nil then
    opts = {}
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

vim.opt.relativenumber = true

-- Number of lines to keep above and below the cursor
vim.opt.scrolloff = 10

-- Set the width of the line number column
vim.opt.numberwidth = 5

vim.o.scroll = 15

-- configer make
vim.g.dotnet_errors_only = true
vim.g.dotnet_show_project_file = false
