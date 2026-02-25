-- Dashboard configuration using snacks.nvim
-- This extends the default AstroNvim dashboard configuration

---@type LazySpec
return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      dashboard = {
        preset = {
          -- Custom header (custom ASCII art)
          header = table.concat({
            "      ___           ___           ___                         ___                   ",
            "     /__/|         /  /\\         /__/\\                       /  /\\         _____    ",
            "    |  |:|        /  /::\\       |  |::\\                     /  /::\\       /  /::\\   ",
            "    |  |:|       /  /:/\\:\\      |  |:|:\\    ___     ___    /  /:/\\:\\     /  /:/\\:\\  ",
            "  __|  |:|      /  /:/~/::\\   __|__|:|\\:\\  /__/\\   /  /\\  /  /:/~/::\\   /  /:/~/::\\ ",
            " /__/\\_|:|____ /__/:/ /:/\\:\\ /__/::::| \\:\\ \\  \\:\\ /  /:/ /__/:/ /:/\\:\\ /__/:/ /:/\\:\\",
            " \\  \\:\\/:::::/ \\  \\:\\/:/__/\\ \\  \\:\\~~\\__\\/  \\  \\:\\  /:/  \\  \\:\\/:/__/\\ \\  \\:\\/:/~/:/",
            "  \\  \\::/~~~~   \\  \\::/       \\  \\:\\         \\  \\:\\/:/    \\  \\::/       \\  \\::/ /:/ ",
            "   \\  \\:\\        \\  \\:\\        \\  \\:\\         \\  \\::/      \\  \\:\\        \\  \\:\\/:/  ",
            "    \\  \\:\\        \\  \\:\\        \\  \\:\\         \\__\\/        \\  \\:\\        \\  \\::/   ",
            "     \\__\\/         \\__\\/         \\__\\/                       \\__\\/         \\__\\/    ",
          }, "\n"),
          -- Custom keybindings
          keys = {
            { key = "f", action = "<Leader>ff", icon = " ", desc = "Find File" },
            { key = "n", action = "<Leader>n", icon = " ", desc = "New File" },
            { key = "r", action = "<Leader>fo", icon = " ", desc = "Recents" },
            { key = "w", action = "<Leader>fw", icon = " ", desc = "Find Word" },
            { key = "q", action = ":qa", icon = "󰩈 ", desc = "Quit" },
          },
        },
      },
    })
  end,
}
