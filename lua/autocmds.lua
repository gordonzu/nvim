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

vim.api.nvim_create_user_command("LspReload", function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.cmd("bdelete")
  vim.cmd("edit #" .. bufnr)
end, {})

-- Ridiculously over-engineered AI crap command to watch filesystem and reload files on save

local lsp_watch_build_job = nil
local lsp_watch_reload_timer = nil

local project_root = vim.fs.normalize("/home/gordonyx/.local/src/c++/aima")

local function is_project_file(path)
  path = vim.fs.normalize(path)

  return path == project_root
    or vim.startswith(path, project_root .. "/")
end

local function is_cpp_file(path)
  return path:match("%.c$")
    or path:match("%.cc$")
    or path:match("%.cpp$")
    or path:match("%.cxx$")
    or path:match("%.h$")
    or path:match("%.hh$")
    or path:match("%.hpp$")
    or path:match("%.hxx$")
    or path:match("%.ixx$")
    or path:match("%.cppm$")
    or path:match("%.mpp$")
end

local function reload_project_buffers()
  local visible_buffers = {}

  -- Reload buffers currently displayed in windows.
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    local path = vim.api.nvim_buf_get_name(bufnr)

    if vim.api.nvim_buf_is_valid(bufnr)
      and vim.bo[bufnr].buftype == ""
      and path ~= ""
      and is_project_file(path)
      and is_cpp_file(path)
      and not vim.bo[bufnr].modified
    then
      visible_buffers[bufnr] = true

      local view = vim.api.nvim_win_call(win, function()
        return vim.fn.winsaveview()
      end)

      vim.api.nvim_win_call(win, function()
        vim.cmd("edit!")
      end)

      vim.api.nvim_win_call(win, function()
        vim.fn.winrestview(view)
      end)
    end
  end

  -- Unload hidden project buffers. They remain listed, but their current
  -- contents and LSP attachment are discarded. They will be read again when
  -- opened.
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if not visible_buffers[bufnr]
      and vim.api.nvim_buf_is_valid(bufnr)
      and vim.api.nvim_buf_is_loaded(bufnr)
      and vim.bo[bufnr].buflisted
      and vim.bo[bufnr].buftype == ""
    then
      local path = vim.api.nvim_buf_get_name(bufnr)

      if path ~= ""
        and is_project_file(path)
        and is_cpp_file(path)
        and not vim.bo[bufnr].modified
      then
        vim.api.nvim_buf_delete(bufnr, { unload = true })
      end
    end
  end

  vim.notify("Reloaded project C/C++ buffers", vim.log.levels.INFO)
end

local function schedule_reload()
  if lsp_watch_reload_timer then
    lsp_watch_reload_timer:stop()
    lsp_watch_reload_timer:close()
    lsp_watch_reload_timer = nil
  end

  lsp_watch_reload_timer = vim.defer_fn(function()
    lsp_watch_reload_timer = nil
    reload_project_buffers()
  end, 300)
end

vim.api.nvim_create_user_command("LspWatchBuild", function()
  if lsp_watch_build_job then
    vim.notify("LspWatchBuild is already running", vim.log.levels.WARN)
    return
  end

  local source_dir = project_root

  if vim.fn.isdirectory(source_dir) == 0 then
    vim.notify("Project directory does not exist: " .. source_dir, vim.log.levels.ERROR)
    return
  end

  lsp_watch_build_job = vim.fn.jobstart({
    "stdbuf",
    "-oL",
    "inotifywait",
    "--monitor",
    "--recursive",
    "--event", "close_write",
    "--format", "%w%f",
    "--exclude", "(^|/)(\\.git|build|\\.cache)(/|$)",
    "--exclude", "(^|/)compile_commands\\.json$",
    source_dir,
  }, {
    stdout_buffered = false,

    on_stdout = function(_, data)
      for _, filename in ipairs(data or {}) do
        filename = vim.trim(filename)

        if filename ~= ""
          and is_project_file(filename)
          and is_cpp_file(filename)
        then
          schedule_reload()
        end
      end
    end,

    on_stderr = function(_, data)
      for _, line in ipairs(data or {}) do
        line = vim.trim(line)

        if line ~= "" then
          vim.schedule(function()
            vim.notify("LspWatchBuild: " .. line, vim.log.levels.WARN)
          end)
        end
      end
    end,

    on_exit = function(_, exit_code)
      vim.schedule(function()
        lsp_watch_build_job = nil

        if exit_code ~= 0 then
          vim.notify(
            "LspWatchBuild stopped with exit code " .. exit_code,
            vim.log.levels.WARN
          )
        else
          vim.notify("LspWatchBuild stopped", vim.log.levels.INFO)
        end
      end)
    end,
  })

  if lsp_watch_build_job <= 0 then
    lsp_watch_build_job = nil
    vim.notify("Could not start inotifywait", vim.log.levels.ERROR)
    return
  end

  vim.notify(
    "Watching project source files for changes",
    vim.log.levels.INFO
  )
end, {
  desc = "Reload project buffers after source changes",
})

vim.api.nvim_create_user_command("LspWatchBuildStop", function()
  if not lsp_watch_build_job then
    vim.notify("LspWatchBuild is not running", vim.log.levels.WARN)
    return
  end

  vim.fn.jobstop(lsp_watch_build_job)
  lsp_watch_build_job = nil

  vim.notify("LspWatchBuild stopped", vim.log.levels.INFO)
end, {
  desc = "Stop project source watcher",
})



