-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = false
vim.opt.colorcolumn = "100"
vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")
vim.diagnostic.config({
	virtual_text = false,
})
vim.opt.tags = ""

-- lvim general options
lvim.log.level = "info"
lvim.format_on_save = {
	enabled = true,
	pattern = "*.lua",
	timeout = 1000,
}
lvim.colorscheme = "tokyonight"

-- keymappings [view all the defaults by pressing <leader>Lk]
-- add your own keymapping
lvim.keys.normal_mode["<Right>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<Left>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode[";f"] = "<CMD>Telescope fd<CR>"
lvim.keys.normal_mode[";o"] = "<CMD>Telescope buffers<CR>"
lvim.keys.normal_mode[";r"] = "<CMD>Telescope live_grep<CR>"
lvim.keys.normal_mode[";t"] = "<CMD>Telescope tags<CR>"
lvim.keys.normal_mode["]e"] = "<CMD>lua vim.diagnostic.goto_next()<CR>"
lvim.keys.normal_mode["[e"] = "<CMD>lua vim.diagnostic.goto_prev()<CR>"
lvim.keys.normal_mode["[q"] = "<CMD>lua vim.diagnostic.setloclist()<CR>"
lvim.keys.normal_mode["[a"] = "<CMD>lua vim.lsp.buf.code_action()<CR>"
lvim.keys.normal_mode["[f"] = "<CMD>lua vim.lsp.buf.format()<CR>"

-- builtin plugin options
lvim.builtin.telescope.theme = nil
lvim.builtin.telescope.defaults.layout_strategy = nil
lvim.builtin.treesitter.rainbow = {
	enable = true,
	extended_mode = true,
	max_file_lines = nil,
}
lvim.builtin.treesitter.autotag.enable = true

-- null-ls options
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ name = "black" },
	{ name = "stylua" },
	{
		name = "prettier",
		---@usage arguments to pass to the formatter
		-- these cannot contain whitespace
		-- options such as `--line-width 80` become either `{"--line-width", "80"}` or `{"--line-width=80"}`
		args = { "--print-width", "100" },
		---@usage only start in these filetypes, by default it will attach to all filetypes it supports
		filetypes = { "typescript", "typescriptreact" },
	},
})

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{ name = "flake8" },
	{
		name = "shellcheck",
		args = { "--severity", "warning" },
	},
})

local code_actions = require("lvim.lsp.null-ls.code_actions")
code_actions.setup({
	{
		name = "proselint",
	},
})

-- additional plugins
lvim.plugins = {
	{
		"dinhhuy258/git.nvim",
		config = function()
			require("git").setup({})
		end,
	},
	{
		"kevinhwang91/promise-async",
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		config = function()
			vim.o.foldcolumn = "1"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			require("ufo").setup({
				fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
					local newVirtText = {}
					local suffix = ("  %d "):format(endLnum - lnum)
					local sufWidth = vim.fn.strdisplaywidth(suffix)
					local targetWidth = width - sufWidth
					local curWidth = 0
					for _, chunk in ipairs(virtText) do
						local chunkText = chunk[1]
						local chunkWidth = vim.fn.strdisplaywidth(chunkText)
						if targetWidth > curWidth + chunkWidth then
							table.insert(newVirtText, chunk)
						else
							chunkText = truncate(chunkText, targetWidth - curWidth)
							local hlGroup = chunk[2]
							table.insert(newVirtText, { chunkText, hlGroup })
							chunkWidth = vim.fn.strdisplaywidth(chunkText)
							-- str width returned from truncate() may less than 2nd argument, need padding
							if curWidth + chunkWidth < targetWidth then
								suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
							end
							break
						end
						curWidth = curWidth + chunkWidth
					end
					table.insert(newVirtText, { suffix, "MoreMsg" })
					return newVirtText
				end,
			})
		end,
	},
	{
		"p00f/nvim-ts-rainbow",
	},
	{
		"windwp/nvim-ts-autotag",
	},
	{
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup({
				options = {
					number = false,
					foldcolumn = 0,
				},
			})
		end,
	},
}

-- setup lsp
if os.getenv("QUERY_DRIVER") then
	require("lvim.lsp.manager").setup("clangd", {
		cmd = {
			"clangd",
			"--query-driver=" .. os.getenv("QUERY_DRIVER"),
		},
	})
else
	require("lvim.lsp.manager").setup("clangd", {
		cmd = {
			"clangd",
		},
	})
end

-- setup dap
require("dap").adapters.lldb = {
	id = "lldb",
	type = "server",
	host = "127.0.0.1",
	port = 13000,
	command = '',
}

require("dap").adapters.cppdbg = {
	id = "cppdbg",
	type = "executable",
	command = "",
}

require("dap").configurations.cpp = {
	{
		name = "Launch file",
		type = "cppdbg",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopAtEntry = true,
	},
	{
		name = "Attach to gdbserver :9090",
		type = "cppdbg",
		request = "launch",
		MIMode = "gdb",
		miDebuggerServerAddress = "192.168.0.117:9090",
		miDebuggerPath = "",
		cwd = "${workspaceFolder}",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
	},
}
