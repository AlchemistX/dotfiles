-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set
map("n", "<c-\\>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root(), win = { style = "float", border = "rounded" } })
end, { desc = "Floating Terminal (Root Dir)" })
map("t", "<C-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("n", "]'", "<cmd>vertical resize -2<cr>", { desc = "Vertical resize -2" })
map("n", "[;", "<cmd>vertical resize +2<cr>", { desc = "Vertical resize +2" })
