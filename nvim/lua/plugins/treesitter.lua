-- Customize Treesitter with explicit parser list
---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    main = "nvim-treesitter.configs",
    lazy = false,
    opts = {
      ensure_installed = {
        -- Core languages
        "lua",
        "python",
        "sql",
        -- Web development
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
        "vue",
        "svelte",
        -- Shell/Config
        "bash",
        "regex",
        "json",
        "yaml",
        "toml",
        -- Documentation
        "markdown",
        "markdown_inline",
        -- "latex", -- Disabled: requires newer tree-sitter CLI
        -- Neorg
        "norg",
        -- Typst
        "typst",
      },
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = false, -- Disable auto-install to avoid unexpected downloads
      sync_install = true, -- Install parsers synchronously during startup
    },
    build = function()
      -- Use TSUpdateSync for synchronous parser installation
      vim.cmd.TSUpdateSync()
    end,
  },
  -- Treesitter textobjects for better navigation
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "User AstroFile",
    opts = {
      enable = true,
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["aC"] = "@conditional.outer",
          ["iC"] = "@conditional.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
        },
      },
      move = {
        enable = true,
        goto_next_start = {
          ["]f"] = "@function.outer",
          ["]c"] = "@class.outer",
        },
        goto_previous_end = {
          ["[f"] = "@function.outer",
          ["[c"] = "@class.outer",
        },
      },
    },
  },
}
