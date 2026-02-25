-- Vimtex - LaTeX editing support
---@type LazySpec
return {
  "lervag/vimtex",
  lazy = false, -- Load immediately for filetype detection
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        autocmds = {
          vimtex_mapping_descriptions = {
            {
              event = "FileType",
              desc = "Set up VimTeX Which-Key descriptions",
              pattern = "tex",
              callback = function(event)
                local wk_avail, wk = pcall(require, "which-key")
                if not wk_avail then
                  return
                end
                wk.add {
                  buffer = event.buf,
                  {
                    mode = "n",
                    { "<localleader>l", group = "VimTeX" },
                    { "<localleader>la", desc = "Show Context Menu" },
                    { "<localleader>lC", desc = "Full Clean" },
                    { "<localleader>lc", desc = "Clean" },
                    { "<localleader>le", desc = "Show Errors" },
                    { "<localleader>lG", desc = "Show Status for All" },
                    { "<localleader>lg", desc = "Show Status" },
                    { "<localleader>li", desc = "Show Info" },
                    { "<localleader>lI", desc = "Show Full Info" },
                    { "<localleader>lk", desc = "Stop VimTeX" },
                    { "<localleader>lK", desc = "Stop All VimTeX" },
                    { "<localleader>lL", desc = "Compile Selection" },
                    { "<localleader>ll", desc = "Compile" },
                    { "<localleader>lm", desc = "Show Imaps" },
                    { "<localleader>lo", desc = "Show Compiler Output" },
                    { "<localleader>lq", desc = "Show VimTeX Log" },
                    { "<localleader>ls", desc = "Toggle Main" },
                    { "<localleader>lt", desc = "Open Table of Contents" },
                    { "<localleader>lT", desc = "Toggle Table of Contents" },
                    { "<localleader>lv", desc = "View Compiled Document" },
                    { "<localleader>lX", desc = "Reload VimTeX State" },
                    { "<localleader>lx", desc = "Reload VimTeX" },
                  },
                }
              end,
            },
          },
        },
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.highlight = opts.highlight or {}
        if type(opts.highlight.disable) == "table" then
          vim.list_extend(opts.highlight.disable, { "latex" })
        else
          opts.highlight.disable = { "latex" }
        end
      end,
    },
  },
  config = function()
    -- Vimtex configuration
    -- See :h vimtex-options for all options

    -- Viewer configuration (choose based on your OS)
    vim.g.vimtex_view_method = "zathura" -- Linux
    -- vim.g.vimtex_view_method = "skim" -- macOS
    -- vim.g.vimtex_view_method = "okular" -- Linux (KDE)
    -- vim.g.vimtex_view_method = "sumatra" -- Windows

    -- Compiler configuration
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      options = {
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
      },
    }

    -- Completion
    vim.g.vimtex_complete_enabled = 1

    -- Indentation
    vim.g.vimtex_indent_enabled = 1

    -- Mappings
    vim.g.vimtex_mappings_enabled = 1

    -- Quickfix
    vim.g.vimtex_quickfix_mode = 2 -- 0: disabled, 1: on error, 2: always

    -- Table of contents
    vim.g.vimtex_toc_config = {
      split_width = 30,
      todo_enabled = 1,
      resize = 1,
      split_pos = "vert rightbelow",
    }

    -- Folding
    vim.g.vimtex_fold_enabled = 0 -- Disable folding (use treesitter instead)
  end,
}
