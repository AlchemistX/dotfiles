return {
  "rebelot/kanagawa.nvim",
  config = function()
    require("kanagawa").setup({
      transparent = true,
      theme = "dragon",
      overrides = function(colors)
        return {
          ["@markup.link.url.markdown_inline"] = { link = "Special" }, -- (url)
          ["@markup.link.label.markdown_inline"] = { link = "WarningMsg" }, -- [label]
          ["@markup.italic.markdown_inline"] = { link = "Exception" }, -- *italic*
          ["@markup.raw.markdown_inline"] = { link = "String" }, -- `code`
          ["@markup.list.markdown"] = { link = "Function" }, -- + list
          ["@markup.list.checked.markdown"] = { link = "WarningMsg" }, -- > checked list item
          ["@markup.quite.markdown"] = { link = "Error" }, -- > blockcode
        }
      end,
    })
    vim.cmd("colorscheme kanagawa")
  end,
  build = function()
    vim.cmd("KanagawaCompile")
  end,
}
