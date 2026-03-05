---@type LazySpec
return {
  {
    "3rd/image.nvim",
    build = false, -- use magick_cli (ImageMagick binary), no rock needed
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {},
      max_width_window_percentage = 60,
      max_height_window_percentage = 40,
      -- keep images visible while typing inside diagram blocks
      clear_in_insert_mode = false,
      -- only render the diagram under the cursor (less noise)
      only_render_image_at_cursor = true,
    },
  },
  {
    "3rd/diagram.nvim",
    dependencies = { "3rd/image.nvim" },
    ft = { "markdown", "norg" },
    config = function()
      require("diagram").setup {
        integrations = {
          require "diagram.integrations.markdown",
          require "diagram.integrations.neorg",
        },
        events = {
          -- re-render after leaving insert mode or entering a window
          render_buffer = { "InsertLeave", "BufWinEnter", "TextChanged" },
          clear_buffer = { "BufLeave" },
        },
        renderer_options = {
          mermaid = {
            theme = "dark",
            background = "transparent",
            scale = 2, -- sharper on HiDPI / Kitty
          },
        },
      }
    end,
  },
}
