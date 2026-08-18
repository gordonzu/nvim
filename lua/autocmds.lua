
require "nvchad.autocmds"

local function disable_bold_italic()
  local groups = {
    -- Vim syntax groups
    "Keyword", "Statement", "Conditional", "Repeat", "Label", "Exception",
    "Type", "StorageClass", "Structure", "Typedef",
    "Function", "Identifier",

    -- Tree-sitter captures (Lua, C#, etc.)
    "@keyword", "@keyword.function", "@keyword.return", "@keyword.operator",
    "@conditional", "@repeat", "@exception",
    "@type", "@type.builtin", "@type.definition",
    "@constructor", "@function", "@function.call", "@function.method",

    -- LSP semantic token fallback names (some themes/plugins use these)
    "@lsp.type.keyword", "@lsp.type.function", "@lsp.type.method",
    "@lsp.type.type", "@lsp.type.class",
  }

  for _, group in ipairs(groups) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    if ok and hl then
      hl.bold = false
      hl.italic = false
      vim.api.nvim_set_hl(0, group, hl)
    end
  end
end

-- Apply now (for initial startup)
disable_bold_italic()

-- Re-apply whenever colorscheme changes (important for NvChad theme switching)
vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
  callback = disable_bold_italic,
})



