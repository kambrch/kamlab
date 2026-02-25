-- Feline.nvim statusline configuration
---@type LazySpec
return {
  "famiu/feline.nvim",
  event = "VeryLazy",
  dependencies = {
    {
      "rebelot/heirline.nvim",
      optional = true,
      opts = function(_, opts)
        opts.statusline = nil
      end,
    },
  },
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      -- Use default feline configuration without explicit theme
      -- Theme colors will be derived from the active colorscheme
      separators = {
        left = { "", "" },
        right = { "", "" },
      },
    })
  end,
}
