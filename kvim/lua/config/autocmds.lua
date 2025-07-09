local M = {}
local Log = require("config.log")

--- Load the default set of autogroups and autocommands.
function M.load_defaults()
  local definitions = {
    {
      "TextYankPost",
      {
        group = "_general_settings",
        pattern = "*",
        desc = "Highlight text on yank",
        callback = function()
          vim.highlight.on_yank({ higroup = "Search", timeout = 100 })
        end,
      },
    },
    {
      "FileType",
      {
        group = "_hide_dap_repl",
        pattern = "dap-repl",
        command = "set nobuflisted",
      },
    },
    {
      "FileType",
      {
        group = "_filetype_settings",
        pattern = { "lua" },
        desc = "fix gf functionality inside .lua files",
        callback = function()
          ---@diagnostic disable: assign-type-mismatch
          -- credit: https://github.com/sam4llis/nvim-lua-gf
          vim.opt_local.include = [[\v<((do|load)file|require|reload)[^''"]*[''"]\zs[^''"]+]]
          vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
          vim.opt_local.suffixesadd:prepend(".lua")
          vim.opt_local.suffixesadd:prepend("init.lua")

          for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
            vim.opt_local.path:append(path .. "/lua")
          end
        end,
      },
    },
    {
      "FileType",
      {
        group = "_buffer_mappings",
        pattern = {
          "qf",
          "help",
          "man",
          "floaterm",
          "lspinfo",
          "lir",
          "lsp-installer",
          "null-ls-info",
          "tsplayground",
          "DressingSelect",
          "Jaq",
          "oil",
        },
        callback = function()
          vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
          vim.opt_local.buflisted = false
        end,
      },
    },
    {
      "VimResized",
      {
        group = "_auto_resize",
        pattern = "*",
        command = [[
          let _auto_resize_current_tab = tabpagenr()
          tabdo wincmd =
          execute 'tabnext' _auto_resize_current_tab
        ]],
      },
    },
    {
      "FileType",
      {
        group = "_filetype_settings",
        pattern = "alpha",
        callback = function()
          vim.cmd([[
            set nobuflisted
          ]])
        end,
      },
    },
    {
      "FileType",
      {
        group = "_filetype_settings",
        pattern = "lir",
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end,
      },
    },
    -- {
    --   "ColorScheme",
    --   {
    --     group = "_lvim_colorscheme",
    --     callback = function()
    --       if lvim.builtin.breadcrumbs.active then
    --         require("lvim.core.breadcrumbs").get_winbar()
    --       end
    --       local statusline_hl = vim.api.nvim_get_hl(0, { name = "StatusLine" })
    --       local cursorline_hl = vim.api.nvim_get_hl(0, { name = "CursorLine" })
    --       local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
    --       vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    --       vim.api.nvim_set_hl(0, "CmpItemKindTabnine", { fg = "#CA42F0" })
    --       vim.api.nvim_set_hl(0, "CmpItemKindCrate", { fg = "#F64D00" })
    --       vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })
    --       vim.api.nvim_set_hl(0, "SLCopilot", { fg = "#6CC644", bg = statusline_hl.bg })
    --       vim.api.nvim_set_hl(0, "SLGitIcon", { fg = "#E8AB53", bg = cursorline_hl.bg })
    --       vim.api.nvim_set_hl(0, "SLBranchName", { fg = normal_hl.fg, bg = cursorline_hl.bg })
    --       vim.api.nvim_set_hl(0, "SLSeparator", { fg = cursorline_hl.fg, bg = statusline_hl.bg })
    --     end,
    --   },
    -- },
    { -- taken from AstroNvim
      "BufEnter",
      {
        group = "_dir_opened",
        nested = true,
        callback = function(args)
          local bufname = vim.api.nvim_buf_get_name(args.buf)
          if require("config.utils").is_directory(bufname) then
            vim.api.nvim_del_augroup_by_name("_dir_opened")
            vim.cmd("do User DirOpened")
            vim.api.nvim_exec_autocmds(args.event, { buffer = args.buf, data = args.data })
          end
        end,
      },
    },
    {
      "FileType",
      {
        group = "_fzf_lua_disable_toggleterm_keys",
        pattern = "fzf",
        desc = "disable toggleterm key map on fzf-lua picker",
        callback = function()
          local keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>", "<C-w>" }
          local fzf_actions = {
            ["<C-h>"] = "<Left>",
            ["<C-j>"] = "<Down>",
            ["<C-k>"] = "<Up>",
            ["<C-l>"] = "<Right>",
            ["<C-w>"] = "<C-w>",
          }
          local prev_maps = {}
          for _, key in ipairs(keys) do
            prev_maps[key] = vim.fn.maparg(key, "t", false, true)
            vim.keymap.set("t", key, fzf_actions[key], { buffer = true })
          end
          vim.api.nvim_create_autocmd("BufLeave", {
            buffer = 0,
            once = true,
            callback = function()
              for _, key in ipairs(keys) do
                if prev_maps[key] and prev_maps[key].rhs ~= "" then
                  vim.keymap.set("t", key, prev_maps[key].rhs, { buffer = true, expr = prev_maps[key].expr == 1 })
                else
                  vim.keymap.del("t", key, { buffer = true })
                end
              end
            end,
          })
        end,
      },
    },
  }

  M.define_autocmds(definitions)
end

--- Clean autocommand in a group if it exists
--- This is safer than trying to delete the augroup itself
---@param name string the augroup name
function M.clear_augroup(name)
  -- defer the function in case the autocommand is still in-use
  Log:debug("request to clear autocmds  " .. name)
  vim.schedule(function()
    pcall(function()
      vim.api.nvim_clear_autocmds({ group = name })
    end)
  end)
end

--- Create autocommand groups based on the passed definitions
--- Also creates the augroup automatically if it doesn't exist
---@param definitions table contains a tuple of event, opts, see `:h nvim_create_autocmd`
function M.define_autocmds(definitions)
  for _, entry in ipairs(definitions) do
    local event = entry[1]
    local opts = entry[2]
    if type(opts.group) == "string" and opts.group ~= "" then
      local exists, _ = pcall(vim.api.nvim_get_autocmds, { group = opts.group })
      if not exists then
        vim.api.nvim_create_augroup(opts.group, {})
      end
    end
    vim.api.nvim_create_autocmd(event, opts)
  end
end

return M
