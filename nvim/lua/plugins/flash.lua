-- Flash.nvim - enhanced search and jump navigation
---@type LazySpec
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["s"] = { function() require("flash").jump() end, desc = "Flash Jump" },
            ["S"] = { function() require("flash").treesitter() end, desc = "Flash Treesitter" },
          },
          x = {
            ["s"] = { function() require("flash").jump() end, desc = "Flash Jump" },
            ["R"] = { function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
          },
          o = {
            ["r"] = { function() require("flash").remote() end, desc = "Remote Flash" },
            ["R"] = { function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            ["s"] = { function() require("flash").jump() end, desc = "Flash Jump" },
            ["S"] = { function() require("flash").treesitter() end, desc = "Flash Treesitter" },
          },
        },
      },
    },
  },
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      labels = "asdfghjklqwertyuiopzxcvbnm",
      search = {
        multi_window = true, -- Search in all windows
        wrap = true, -- Wrap around file
        mode = "exact", -- Search mode: exact, search, fuzzy
      },
      jump = {
        jumplist = true, -- Save to jumplist
        autojump = false, -- Don't auto-jump on single match
      },
      label = {
        uppercase = true, -- Allow uppercase labels
        distance = true, -- Prioritize closer targets
      },
      highlight = {
        backdrop = true, -- Show backdrop
        matches = true, -- Highlight matches
      },
      modes = {
        search = { enabled = false }, -- Disable for / search
        char = {
          enabled = true, -- Enable for f/F/t/T motions
          jump_labels = false, -- Don't show jump labels for char motions
          multi_line = true, -- Search across lines
        },
      },
    })
  end,
}
