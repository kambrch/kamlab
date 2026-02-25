-- Mini.surround - fast and lightweight surround plugin
---@type LazySpec
return {
  "echasnovski/mini.surround",
  event = "User AstroFile",
  keys = {
    { "gs", desc = "+surround" },
    { "gsa", desc = "Add surrounding" },
    { "gsd", desc = "Delete surrounding" },
    { "gsr", desc = "Replace surrounding" },
    { "gsf", desc = "Find surrounding" },
    { "gsF", desc = "Find surrounding (backward)" },
    { "gsh", desc = "Highlight surrounding" },
    { "gsn", desc = "Update n-th surrounding" },
  },
  opts = {
    mappings = {
      add = "gsa", -- Add surrounding in Normal and Visual modes
      delete = "gsd", -- Delete surrounding
      find = "gsf", -- Find surrounding (forward)
      find_left = "gsF", -- Find surrounding (backward)
      highlight = "gsh", -- Highlight surrounding
      replace = "gsr", -- Replace surrounding
      update_n_lines = "gsn", -- Update `n_lines`
    },
  },
}
