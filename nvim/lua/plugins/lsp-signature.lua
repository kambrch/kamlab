-- Lsp-signature.nvim - function signature help
---@type LazySpec
return {
  "ray-x/lsp_signature.nvim",
  event = "User AstroFile",
  main = "lsp_signature",
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      bind = true, -- Bind signature help to a key
      floating_window = true, -- Show in floating window
      hint_enable = false, -- Disable virtual hints (use floating window instead)
      doc_lines = 5, -- Number of documentation lines to show
      max_height = 10, -- Max floating window height
      max_width = 100, -- Max floating window width
      wrap = true, -- Wrap long lines
      handler_opts = { border = "rounded" }, -- Border style
      fix_pos = true, -- Fix position to stay on screen
      padding = " ", -- Padding characters
      transparency = 10, -- Window transparency (0-100)
      close_timeout = 3000, -- Close timeout in ms
      hi_parameter = "LspSignatureActiveParameter", -- Highlight group for active parameter
    })
  end,
  specs = {
    {
      "folke/noice.nvim",
      optional = true,
      opts = {
        lsp = {
          signature = { enabled = false },
          hover = { enabled = false },
        },
      },
    },
    {
      "AstroNvim/astrolsp",
      optional = true,
      opts = { features = { signature_help = false } },
    },
  },
}
