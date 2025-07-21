return {
  "ahmedkhalf/project.nvim",
  opts = function(_, opts)
    ---@usage set to true to disable setting the current-woriking directory
    --- Manual mode doesn't automatically change your root directory, so you have
    --- the option to manually do so using `:ProjectRoot` command.
    opts.manual_mode = false

    ---@usage Methods of detecting the root directory
    --- Allowed values: **"lsp"** uses the native neovim lsp
    --- **"pattern"** uses vim-rooter like glob pattern matching. Here
    --- order matters: if one is not detected, the other is used as fallback. You
    --- can also delete or rearangne the detection methods.
    -- detection_methods = { "lsp", "pattern" },
    -- NOTE: lsp detection will get annoying with multiple langs in one project
    opts.detection_methods = { "pattern" }

    -- All the patterns used to detect root dir, when **"pattern"** is in
    -- detection_methods
    opts.patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "pom.xml", "meson.build" }

    -- Table of lsp clients to ignore by name
    -- eg: { "efm", ... }
    -- ignore_lsp = {}

    -- Don't calculate root dir on specific directories
    -- Ex: { "~/.cargo/*", ... }
    -- exclude_dirs = {}

    -- Show hidden files in telescope
    opts.show_hidden = false

    -- When set to false, you will get a message when project.nvim changes your
    -- directory.
    -- silent_chdir = true

    -- What scope to change the directory, valid options are
    -- * global (default)
    -- * tab
    -- * win
    opts.scope_chdir = "global"

    return opts
  end,
}
