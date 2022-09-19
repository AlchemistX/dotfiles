local status, saga = pcall(require, "lspsaga")
if not status then
	return
end

local keymap = vim.keymap.set

saga.init_lsp_saga()

local opts = { noremap = true, silent = true }
keymap("n", "<C-j>", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts)
keymap("n", "K", "<Cmd>Lspsaga hover_doc<CR>", opts)
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", opts)
keymap("n", "gd", "<Cmd>Lspsaga peek_definition<CR>", opts)
keymap("n", "gr", "<Cmd>Lspsaga rename<CR>", opts)
keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
keymap("n", "<leader>ld", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
keymap("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
keymap("n", "[E", function()
	require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, opts)
keymap("n", "]E", function()
	require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, opts)
