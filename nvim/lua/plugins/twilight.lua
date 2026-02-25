-- Twilight.nvim - focus mode by dimming surrounding text
---@type LazySpec
return {
  "folke/twilight.nvim",
  cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>uW"] = { "<Cmd>Twilight<CR>", desc = "Toggle Twilight" },
          },
        },
      },
    },
  },
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      dimming = {
        alpha = 0.3, -- Amount of dimming (0.0 to 1.0)
        color = { "Normal" }, -- Color to use for dimming
        inactive = false, -- Don't dim other windows
      },
      context = 12, -- Number of lines to show around cursor
      treesitter = true, -- Use treesitter for context
      expand = { "function", "method", "table", "if_statement" },
      exclude = { "markdown", "text", "help", "neo-tree", "lazy", "mason" },
    })
  end,
}
