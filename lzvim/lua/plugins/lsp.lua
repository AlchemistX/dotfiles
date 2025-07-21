return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      bitbake_language_server = {
        cmd = { "language-server-bitbake", "--stdio" },
        filetypes = { "bitbake", "bbappend", "bbclass", "inc" },
        root_dir = require("lspconfig.util").root_pattern("conf/layer.conf", ".git"),
      },
    },
    setup = {
      clangd = function(_, opts)
        local query_driver = os.getenv("QUERY_DRIVER")
        if query_driver and #query_driver > 0 then
          table.insert(opts.cmd, "--query-driver=" .. query_driver)
        end

        local clangd_ext_opts = require("lazy.core.plugin").values(
          require("lazy.core.config").plugins["clangd_extensions.nvim"],
          "opts",
          false
        )

        require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, {
          server = opts,
        }))

        return false
      end,
    },
  },
}
