-- Garbage-day.nvim - LSP memory management
---@type LazySpec
return {
  "zeioth/garbage-day.nvim",
  event = "User AstroLspSetup",
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      aggressive_mode = false, -- Don't stop LSP when switching filetypes
      aggresive_mode_ignore = {
        filetype = { "", "markdown", "text", "org", "tex", "asciidoc", "rst" },
        buftype = { "nofile" },
      },
      excluded_lsp_clients = { "null-ls", "jdtls", "marksman", "lua_ls" },
      grace_period = 60 * 15, -- 15 minutes before stopping inactive LSP
      notifications = false, -- Don't show notifications
      retries = 3, -- Number of retries
      timeout = 1000, -- Timeout per retry in ms
      wakeup_delay = 0, -- Delay before waking LSP in ms
    })
  end,
}
