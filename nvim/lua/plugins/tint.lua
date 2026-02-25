-- Tint.nvim - window dimming for inactive windows
---@type LazySpec
return {
  "levouh/tint.nvim",
  event = "User AstroFile",
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      tint = -45, -- Darken colors (negative = dim, positive = brighten)
      saturation = 0.6, -- Saturation to preserve (0.0 to 1.0)
      highlight_ignore_patterns = {
        "WinSeparator",
        "NeoTree.*",
        "Status.*",
        "BufferLine.*",
        "LspSignatureActiveParameter",
        "Diagnostic.*",
        "Everforest.*",
      },
      tint_background_colors = false,
    })
  end,
}
