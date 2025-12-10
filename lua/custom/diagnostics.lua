-- diagnostics.lua
-- custom errors

local M = {}

function M.setup()
  vim.diagnostic.config {
    virtual_text = true,
    virtual_lines = false,
    signs = true,
    underline = true,
    float = { border = "rounded" },
  }
end

return M
