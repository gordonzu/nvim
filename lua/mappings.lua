require "nvchad.mappings"
local harpoon = require("harpoon")

harpoon:setup()

local map = vim.keymap.set

map("n", "<leader>a", function() harpoon:list():add() end , { desc = "add buffer to harpoon" })
map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end , { desc = "show harpoon window" })
map("n", "1", function() harpoon:list():select(1) end, { desc = "pick 1st buff" })
map("n", "2", function() harpoon:list():select(2) end, { desc = "pick 2nd buff" })
map("n", "3", function() harpoon:list():select(3) end, { desc = "pick 3rd buff" })
map("n", "4", function() harpoon:list():select(4) end, { desc = "pick 4th buff" })
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>x", ":bd<CR>", { desc = "delete open buffer" })
map("n", "<leader>[", ":bn<CR>", { desc = "next buffer" })
map("n", "<leader>]", ":bp<CR>", { desc = "previous buffer" })
map("i", "jk", "<ESC>")
map("n", "-", "<CMD>Oil --float<CR>")

map("n", "<leader>cr", "<cmd>LspReload<cr>", { desc = "Close and reopen buffer(lsp reload)" })

vim.keymap.set("n", "<leader>cb", function()
  -- Delete .pcm files
  vim.system({ "find", "build", "-name", "*.pcm", "-delete" })
  
  -- Rebuild
  vim.system(
    { "bash", "./watch" },
    { text = true, cwd = vim.fn.getcwd() },
    function(result)
      vim.schedule(function()
        if result.code == 0 then
          -- Kill clangd
          vim.system({ "pkill", "-9", "clangd" })
          vim.uv.sleep(500)
          
          -- Reload current buffer
          local bufnr = vim.api.nvim_get_current_buf()
          vim.cmd("bdelete")
          vim.cmd("edit #" .. bufnr)
          
          vim.notify("Build complete and buffer reloaded", vim.log.levels.INFO)
        else
          vim.notify("Build failed: " .. (result.stderr or "unknown error"), vim.log.levels.ERROR)
        end
      end)
    end
  )
end, { desc = "Build, restart clangd, and reload buffer" })
