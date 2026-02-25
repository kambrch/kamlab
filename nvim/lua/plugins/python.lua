local python = require "utils.python"

---@type LazySpec
return {

  -- LSP: basedpyright for Python with virtual environment support.
  {
    "AstroNvim/astrolsp",
    opts = function(_, opts)
      opts.servers = require("astrocore").list_insert_unique(opts.servers or {}, { "basedpyright" })
      opts.handlers = vim.tbl_deep_extend("force", opts.handlers or {}, {
        pyright = false,
      })
      opts.formatting = opts.formatting or {}
      opts.formatting.format_on_save = vim.tbl_deep_extend("force", opts.formatting.format_on_save or {}, {
        enabled = true,
        allow_filetypes = { "python" },
      })

      local function set_python_path(config, root_dir)
        local resolved_root = python.find_root(root_dir)
        local python_path = python.resolve_python(resolved_root)
        config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
          python = { pythonPath = python_path },
        })
      end

      opts.config = opts.config or {}
      opts.config.basedpyright = vim.tbl_deep_extend("force", opts.config.basedpyright or {}, {
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
            },
          },
        },
        before_init = function(_, config) set_python_path(config, config.root_dir or vim.fn.getcwd()) end,
        on_new_config = function(new_config, root_dir)
          set_python_path(new_config, root_dir)
        end,
      })
    end,
  },
  -- Formatter + diagnostics via none-ls.
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      -- Ruff builtins were removed from none-ls; keep Python sources empty here.
      opts.sources = require("astrocore").list_insert_unique(opts.sources, {})
    end,
  },
  -- Ensure tools are installed via Mason.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, {
        "basedpyright",
        "ruff",
      })
    end,
  },
}
