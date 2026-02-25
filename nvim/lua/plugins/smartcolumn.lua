-- Smartcolumn.nvim - color column configuration
---@type LazySpec
return {
  "m4xshen/smartcolumn.nvim",
  event = { "InsertEnter", "User AstroFile" },
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      colorcolumn = "120",
      disabled_filetypes = {
        "alpha",
        "help",
        "markdown",
        "text",
        "neo-tree",
        "lazy",
        "oil",
        "dashboard",
        "TelescopePrompt",
        "toggleterm",
        "Trouble",
        "fugitive",
        "git",
        "gitcommit",
        "gitrebase",
      },
      custom_colorcolumn = {
        lua = "120",
        python = "100",
        go = "120",
        rust = "120",
        javascript = "120",
        typescript = "120",
      },
      scope = "file",
      editorconfig = true,
    })
  end,
}
