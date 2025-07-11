return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  config = function()
    local highlight = {
      "RainbowRed",
      "RainbowYellow",
      "RainbowBlue",
      "RainbowOrange",
      "RainbowGreen",
      "RainbowViolet",
      "RainbowCyan",
    }

    local hooks = require("ibl.hooks")
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#a07a85" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#a0926a" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#7a85a0" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#a0856a" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#85a07a" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#9292a0" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#7aa0a0" })
    end)

    require("ibl").setup({
      exclude = {
        buftypes = { "terminal", "nofile" },
        filetypes = {
          "help",
          "startify",
          "dashboard",
          "lazy",
          "neogitstatus",
          "NvimTree",
          "Trouble",
          "text",
        },
      },
      indent = {
        char = require("config.icons").ui.LineLeft,
      },
      scope = {
        enabled = true,
        show_start = true,
        highlight = highlight,
      },
    })
  end,
}
