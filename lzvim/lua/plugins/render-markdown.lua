return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "norg", "rmd", "org", "codecompanion", "copilot-chat" },
  opts = function(_, opts)
    opts.code = {
      sign = true,
      language_border = " ",
      language_left = "",
      language_right = "",
      width = "full",
      right_pad = 2,
    }
    opts.heading = {
      sign = true,
      position = "inline",
      icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
    }
    opts.checkbox = {
      enabled = true,
    }
    return opts
  end,
}
