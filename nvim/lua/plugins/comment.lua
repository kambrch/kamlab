---@type LazySpec
return {
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    keys = { "<space>c", "<space>C", "<space>cm" },
    opts = {
      mappings = {
        comment = "<space>c",
        comment_line = "<space>C",
        textobject = "<space>cm",
      },
    },
    config = function(_, opts)
      require("mini.comment").setup(opts)
      for _, key in ipairs({ "gc", "gcc", "gco", "gcO" }) do
        pcall(vim.keymap.del, "n", key)
      end
    end,
  },
}
