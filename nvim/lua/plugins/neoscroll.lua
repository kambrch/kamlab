-- Neoscroll.nvim - smooth scrolling
---@type LazySpec
return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
      hide_cursor = true, -- Hide cursor during scroll
      stop_eof = true, -- Stop at end of file
      respect_scrolloff = false, -- Don't respect scrolloff setting
      cursor_scrolls_alone = true, -- Cursor scrolls independently
      duration_multiplier = 1.0, -- Animation duration multiplier
      easing = "linear", -- Easing function: linear, in_quad, out_quad, in_out_quad
      performance_mode = false, -- Disable animations for better performance
    })
  end,
}
