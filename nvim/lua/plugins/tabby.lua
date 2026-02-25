-- Tabby AI code completion configuration
-- Provides inline code completion powered by Tabby server

---@type LazySpec
return {
  "TabbyML/vim-tabby",
  lazy = false,
  dependencies = { "neovim/nvim-lspconfig" },
  init = function()
    -- Configure tabby-agent to start via stdio
    vim.g.tabby_agent_start_command = { "npx", "tabby-agent", "--stdio" }
    -- Auto-trigger completions as you type
    vim.g.tabby_inline_completion_trigger = "auto"
    -- Keybinding to accept completion (using Tab for standard behavior)
    vim.g.tabby_inline_completion_keybinding_accept = "<Tab>"
    -- Keybinding to dismiss completion
    vim.g.tabby_inline_completion_keybinding_trigger_or_dismiss = "<C-k>"
  end,
}
