---@type LazySpec
return {
  "RishabhRD/nvim-cheat.sh",
  cmd = { "Cheat", "CheatWithoutComments", "CheatList", "CheatListWithoutComments" },
  dependencies = { "RishabhRD/popfix" },
  init = function()
    -- nvim-cheat.sh reads a global instead of exposing setup()
    vim.g.cheat_default_window_layout = "float"
  end,
  keys = {
    { "<Leader>cc", "<cmd>Cheat<cr>", desc = "Cheat sheet search (with comments)" },
    { "<Leader>cC", "<cmd>CheatWithoutComments<cr>", desc = "Cheat sheet search (no comments)" },
    { "<Leader>cl", "<cmd>CheatList<cr>", desc = "List all symbols (with comments)" },
    { "<Leader>cL", "<cmd>CheatListWithoutComments<cr>", desc = "List all symbols (no comments)" },
  },
}
