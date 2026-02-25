-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  -- bars and lines
  { import = "astrocommunity.bars-and-lines.feline-nvim" },
  { import = "astrocommunity.bars-and-lines.smartcolumn-nvim" },
  { import = "astrocommunity.bars-and-lines.vim-illuminate" },
  -- colour
  { import = "astrocommunity.color.nvim-highlight-colors" },
  { import = "astrocommunity.color.tint-nvim" },
  { import = "astrocommunity.color.twilight-nvim" },
  -- colorscheme - using default AstroNvim theme
  -- cheat sheets
  { import = "astrocommunity.workflow.cheat-sh" },
  { import = "astrocommunity.colorscheme.everforest", enabled = false },
  -- comments
  -- completion
  --{ import = "astrocommunity.completion.codex-nvim" },
  -- Tabby now configured directly in lua/plugins/tabby.lua
  -- diagnostics
  { import = "astrocommunity.diagnostics.error-lens-nvim", enabled = false }, -- Removed: duplicate with tiny-inline-diagnostic
  { import = "astrocommunity.diagnostics.tiny-inline-diagnostic-nvim" },
  -- editing-suport
  { import = "astrocommunity.editing-support.auto-save-nvim" },
  { import = "astrocommunity.editing-support.comment-box-nvim" },
  { import = "astrocommunity.editing-support.dial-nvim" },
  { import = "astrocommunity.editing-support.hypersonic-nvim" },
  { import = "astrocommunity.editing-support.yanky-nvim", enabled = false }, -- Using custom config in plugins/yanky.lua
  -- indent
  { import = "astrocommunity.indent.indent-blankline-nvim" },
  -- keybindings
  --{ import = "astrocommunity.keybinding.mini-clue" },
  -- lsp
  { import = "astrocommunity.lsp.garbage-day-nvim" },
  { import = "astrocommunity.lsp.lsp-lens-nvim" },
  { import = "astrocommunity.lsp.lsp-signature-nvim" },
  -- Markdown-and-LaTeX
  { import = "astrocommunity.markdown-and-latex.markview-nvim" },
  { import = "astrocommunity.markdown-and-latex.vimtex" },
  -- motion
  { import = "astrocommunity.motion.flash-nvim" },
  -- note-taking / language packs (see plugins/language_packs.lua)
  -- pack
  { import = "astrocommunity.pack.fish" },
  -- scrolling
  { import = "astrocommunity.scrolling.neoscroll-nvim" },
  -- snippets
  { import = "astrocommunity.snippet.nvim-snippets" },
  -- split-and-windows
  { import = "astrocommunity.split-and-window.windows-nvim" },
  -- workflow
  --{ import = "astrocommunity.workflow.precognition-nvim" },
}
