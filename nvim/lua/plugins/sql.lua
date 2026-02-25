---@type LazySpec
return {
  -- LSP for SQL - lazy load with filetype
  {
    "AstroNvim/astrolsp",
    opts = function(_, opts)
      opts.servers = require("astrocore").list_insert_unique(opts.servers or {}, { "sqls" })
      opts.config = opts.config or {}
      opts.config.sqls = vim.tbl_deep_extend("force", opts.config.sqls or {}, {
        on_attach = function(client)
          -- Disable formatting due to bugs: https://github.com/sqls-server/sqls/issues/149
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      })
    end,
  },
  -- Ensure SQL tools are installed via Mason - lazy load
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, {
        "sqls",
        "sqlfluff",
      })
    end,
  },
}
