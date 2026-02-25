---@type LazySpec
return {
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    init = function() vim.g.smart_splits_multiplexer_integration = "zellij" end,
    opts = {},
    keys = {
      { "<leader>z", desc = "+Zellij/Nav" },
      { "<leader>zh", function() require("smart-splits").move_cursor_left() end, desc = "Move left (split/pane)" },
      { "<leader>zj", function() require("smart-splits").move_cursor_down() end, desc = "Move down (split/pane)" },
      { "<leader>zk", function() require("smart-splits").move_cursor_up() end, desc = "Move up (split/pane)" },
      { "<leader>zl", function() require("smart-splits").move_cursor_right() end, desc = "Move right (split/pane)" },
      { "<leader>zH", function() require("smart-splits").resize_left() end, desc = "Resize left" },
      { "<leader>zJ", function() require("smart-splits").resize_down() end, desc = "Resize down" },
      { "<leader>zK", function() require("smart-splits").resize_up() end, desc = "Resize up" },
      { "<leader>zL", function() require("smart-splits").resize_right() end, desc = "Resize right" },
    },
  },
}
