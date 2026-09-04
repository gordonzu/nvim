require "nvchad.mappings"
local harpoon = require("harpoon")

harpoon:setup()

local map = vim.keymap.set

map("n", "<leader>a", function() harpoon:list():add() end , { desc = "add buffer to harpoon" })
map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end , { desc = "show harpoon window" })
map("n", "<C-h>", function() harpoon:list():select(1) end, { desc = "pick 1st buff" })
map("n", "<C-t>", function() harpoon:list():select(2) end, { desc = "pick 2nd buff" })
map("n", "<C-n>", function() harpoon:list():select(3) end, { desc = "pick 3rd buff" })
map("n", "<C-s>", function() harpoon:list():select(4) end, { desc = "pick 4th buff" })
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>x", ":bd<CR>", { desc = "delete open buffer" })
map("n", "<leader>[", ":bn<CR>", { desc = "next buffer" })
map("n", "<leader>]", ":bp<CR>", { desc = "previous buffer" })
map("i", "jk", "<ESC>")
map("n", "-", "<CMD>Oil --float<CR>")
