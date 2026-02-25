-- Vim-illuminate - reference highlighting configuration
---@type LazySpec
return {
  "RRethy/vim-illuminate",
  event = "User AstroFile",
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      providers = { "lsp", "treesitter" },
      delay = 150,
      filetypes_denylist = {
        "dirbuf",
        "dirvish",
        "fugitive",
        "neo-tree",
        "TelescopePrompt",
        "lazy",
        "mason",
        "oil",
        "alpha",
        "dashboard",
        "toggleterm",
        "Trouble",
        "help",
        "markdown",
        "text",
      },
      under_cursor = true,
      large_file_cutoff = 5000,
      large_file_config = {
        providers = { "regex" },
        delay = 300,
      },
      min_count_to_highlight = 2,
    })
  end,
  specs = {
    {
      "catppuccin",
      optional = true,
      ---@type CatppuccinOptions
      opts = { integrations = { illuminate = true } },
    },
  },
}
