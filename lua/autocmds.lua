require "nvchad.autocmds"

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { buffer = bufnr })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr })
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr })
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { buffer = bufnr })
  end,
})

vim.api.nvim_create_user_command("NvChadExportCheatsheet", function(opts)
  local path = opts.args ~= "" and opts.args or nil
  require("export_cheatsheet").export(path)
end, { nargs = "?", complete = "file" })

vim.api.nvim_create_user_command("CopyLineDiagnostic", function()
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diags = vim.diagnostic.get(0, { lnum = lnum })
  if #diags == 0 then
    vim.notify("No diagnostic on current line", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", diags[1].message)
  vim.notify("Copied diagnostic to clipboard")
end, {})

-- User command: put current buffer diagnostics into quickfix and open it
vim.api.nvim_create_user_command("DiagToQF", function()
  vim.diagnostic.setqflist({ open = true })
end, {})

vim.api.nvim_create_user_command("ClangdRefresh", function()
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.name == "clangd" then
      vim.lsp.stop_client(client.id, true)
    end
  end
  vim.defer_fn(function()
    vim.cmd("edit")
  end, 120)
end, {})

