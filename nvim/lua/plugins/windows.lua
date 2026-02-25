-- Windows.nvim - automatic window width management
---@type LazySpec
return {
  "anuvyklack/windows.nvim",
  dependencies = {
    "anuvyklack/middleclass",
    "anuvyklack/animation.nvim",
    {
      "AstroNvim/astrocore",
      opts = {
        options = {
          opt = {
            winwidth = 10,
            winminwidth = 10,
            equalalways = false,
          },
        },
      },
    },
  },
  cmd = {
    "WindowsMaximize",
    "WindowsMaximizeVertically",
    "WindowsMaximizeHorizontally",
    "WindowsEqualize",
    "WindowsEnableAutowidth",
    "WindowsDisableAutowidth",
    "WindowsToggleAutowidth",
  },
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      autowidth = {
        enable = true,
        winwidth = 5, -- Minimum window width
        filetype = {
          help = 2,
          markdown = 80,
        },
      },
      ignore = {
        buftype = { "quickfix", "terminal" },
        filetype = {
          "undotree",
          "gundo",
          "NvimTree",
          "neo-tree",
          "Outline",
          "lazy",
          "mason",
          "oil",
          "TelescopePrompt",
          "toggleterm",
        },
      },
      animation = {
        enable = true,
        duration = 250, -- Animation duration in ms
        fps = 30, -- Animation FPS
        easing = "in_out_sine", -- Easing function
      },
    })
  end,
}
