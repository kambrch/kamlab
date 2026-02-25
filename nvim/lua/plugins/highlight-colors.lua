-- Nvim-highlight-colors - color preview in code
---@type LazySpec
return {
  "brenoprata10/nvim-highlight-colors",
  event = "User AstroFile",
  cmd = "HighlightColors",
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>uz"] = { function() vim.cmd.HighlightColors "Toggle" end, desc = "Toggle color highlight" },
          },
        },
      },
    },
  },
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      render = "background",
      enable_hex = true,
      enable_rgb = true,
      enable_hsl = true,
      enable_hsl_without_function = true,
      enable_var_usage = true,
      enable_named_colors = true,
      enable_tailwind = false,
      virtual_symbol = "■",
      virtual_symbol_position = "inline",
      exclude_filetypes = { "markdown", "text", "help", "neo-tree" },
    })
  end,
  specs = {
    { "NvChad/nvim-colorizer.lua", optional = true, enabled = false },
  },
}
