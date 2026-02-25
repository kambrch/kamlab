-- Auto-save.nvim - automatically save files
---@type LazySpec
return {
  "okuuva/auto-save.nvim",
  event = { "User AstroFile", "InsertEnter" },
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      enabled = true,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost", "QuitPre" },
        defer_save = { "InsertLeave", "TextChanged" },
        cancel_deferred_save = { "InsertEnter" },
      },
      condition = function(buf)
        local filetype = vim.fn.getbufvar(buf, "&filetype")
        -- Don't auto-save for these filetypes
        if vim.tbl_contains({ "markdown", "gitcommit", "gitrebase", "tex", "org" }, filetype) then
          return false
        end
        return true
      end,
      write_all_buffers = false,
      noautocmd = false,
      lockmarks = false,
      debounce_delay = 1500,
      debug = false,
    })
  end,
}
