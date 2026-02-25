---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    opts = {
      autocmds = {
        wrap_text_like = {
          {
            event = "FileType",
            pattern = { "text", "markdown", "tex", "plaintex", "latex", "typst" },
            desc = "Enable wrapping for text/markdown/latex",
            callback = function()
              vim.opt_local.wrap = true
              vim.opt_local.linebreak = true
            end,
          },
        },
      },
    },
  },
}
