-- Lsp-lens.nvim - code lens display (references, definitions, implements)
---@type LazySpec
return {
  "VidocqH/lsp-lens.nvim",
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      enable = true,
      include_declaration = false, -- Don't include declaration in references count
      hide_zero_counts = true, -- Hide sections with zero counts
      sections = {
        definition = function(count)
          return " " .. count
        end,
        references = function(count)
          return " " .. count
        end,
        implements = function(count)
          return " " .. count
        end,
      },
      separator = " | ",
      ignore_filetype = { "prisma", "markdown", "text", "help", "lua" },
      target_symbol_kinds = {
        vim.lsp.protocol.SymbolKind.Function,
        vim.lsp.protocol.SymbolKind.Method,
        vim.lsp.protocol.SymbolKind.Class,
      },
    })
  end,
}
