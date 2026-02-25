-- Indent-blankline.nvim - indent guides
---@type LazySpec
return {
  "lukas-reineke/indent-blankline.nvim",
  event = "User AstroFile",
  main = "ibl",
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      enabled = true,
      indent = {
        char = "▎",
        highlight = "IblIndent",
        smart_indent_cap = true,
        priority = 1,
      },
      scope = {
        enabled = true,
        char = "▎",
        show_start = true,
        show_end = true,
        highlight = "IblScope",
        include = { node_type = {} },
        exclude = {
          language = {},
          node_type = {
            ["*"] = { "source_file", "program" },
            lua = { "chunk" },
            python = { "module" },
          },
        },
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "Trouble",
          "lazy",
          "neo-tree",
          "TelescopePrompt",
          "TelescopeResults",
          "gitcommit",
          "markdown",
          "text",
          "oil",
          "toggleterm",
        },
        buftypes = { "terminal", "nofile", "quickfix", "prompt" },
      },
      whitespace = {
        highlight = "IblWhitespace",
        remove_blankline_trail = true,
      },
      debounce = 200,
    })
  end,
}
