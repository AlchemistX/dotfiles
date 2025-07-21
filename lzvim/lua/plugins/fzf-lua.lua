return {
  "ibhagwan/fzf-lua",
  opts = function(_, opts)
    opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
      builtin = {
        ["<C-d>"] = "preview-page-down",
        ["<C-u>"] = "preview-page-up",
        ["<C-f>"] = "preview-half-page-down",
        ["<C-b>"] = "preview-half-page-up",
      },
    })
  end,
  keys = {
    { ";f", ":FzfLua files<Enter>", desc = "Find file in project directory" },
    { ";g", ":FzfLua live_grep<Enter>", desc = "Find by grapping in project directory" },
    { ";o", ":FzfLua buffers<Enter>", desc = "Find buffers" },
    { ";l", ":FzfLua oldfiles<Enter>", desc = "Find files of edited last" },
    { ";h", ":FzfLua helptags<Enter>", desc = "Find help" },
    { ";k", ":FzfLua keymaps<Enter>", desc = "Find keymaps" },
    { ";b", ":FzfLua builtin<Enter>", desc = "Find builtin" },
    { ";w", ":FzfLua grep_cword<Enter>", desc = "Find current word" },
    { ";W", ":FzfLua grep_cWORD<Enter>", desc = "Find current WORD" },
    { ";d", ":FzfLua diagnostics_document<Enter>", desc = "Find diagnostics" },
    { ";r", ":FzfLua resume<Enter>", desc = "Find resume" },
    { ";/", ":FzfLua lgrep_curbuf<Enter>", desc = "Live grep the current buffer" },
  },
}
