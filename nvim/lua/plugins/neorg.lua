---@type LazySpec
return {
  {
    "nvim-neorg/neorg",
    name = "neorg",
    ft = "norg",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "folke/zen-mode.nvim",
        lazy = true,
        opts = {
          window = {
            width = 0.8,
            height = 0.85,
            options = { signcolumn = "no" },
          },
          plugins = {
            kitty = { enabled = false },
          },
        },
      },
    },
    init = function()
      local key = "<space>Ne"
      vim.keymap.set("n", key, function()
        vim.keymap.del("n", key)
        require("lazy").load({ plugins = "neorg" })
        local keys = vim.api.nvim_replace_termcodes(key, true, false, true)
        vim.api.nvim_feedkeys(keys, "n", false)
      end, { desc = "Load Neorg" })
    end,
    opts = function()
      local data_path = vim.fn.stdpath "data"
      local workspace_path = data_path .. "/neorg"
      vim.fn.mkdir(workspace_path, "p")

      return {
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = workspace_path,
              },
            },
          },
          ["core.keybinds"] = {
            config = {
              default_keybinds = true,
              neorg_leader = "<space>N",
            },
          },
          ["core.journal"] = {
            config = {
              workspace = "notes",
            },
          },
          ["core.presenter"] = {
            config = {
              zen_mode = "zen-mode",
            },
          },
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },
          ["core.integrations.nvim-cmp"] = {},
          ["core.neorgcmd"] = {},
          ["core.summary"] = {},
        },
      }
    end,
    config = function(_, opts)
      require("neorg").setup(opts)
      local callbacks = require("neorg.core.callbacks")
      callbacks.on_event("core.dirman.events.workspace_added", function(_, content)
        local name = content[1] or "unknown"
        vim.notify(("Neorg workspace %q registered."):format(name), vim.log.levels.INFO, { title = "Neorg" })
      end)
      callbacks.on_event("core.dirman.events.workspace_changed", function(_, content)
        local ws = content.new
        local new_name = (ws and ws[1]) or "default"
        vim.notify(("Neorg workspace switched to %s."):format(new_name), vim.log.levels.INFO, { title = "Neorg" })
      end)
      local ok, which_key = pcall(require, "which-key")
      if ok and which_key then
        which_key.add({
          { "<space>Nn", "<cmd>Neorg index<CR>", desc = "Workspace Index" },
          { "<space>Nj", "<cmd>Neorg journal today<CR>", desc = "Journal Today" },
          { "<space>Np", "<cmd>Neorg presenter start<CR>", desc = "Presenter" },
          { "<space>Nt", "<cmd>Neorg toc<CR>", desc = "Table of contents" },
          { "<space>Ns", "<cmd>Neorg generate-workspace-summary<CR>", desc = "Workspace summary" },
        }, { mode = "n", version = 2 })
      end
      local leader = "<space>N"
      vim.keymap.set("n", leader .. "n", "<cmd>Neorg index<CR>", { desc = "Neorg index" })
      vim.keymap.set("n", leader .. "j", "<cmd>Neorg journal today<CR>", { desc = "Neorg journal (today)" })
      vim.keymap.set("n", leader .. "p", "<cmd>Neorg presenter start<CR>", { desc = "Neorg presenter" })
      vim.keymap.set("n", leader .. "s", "<cmd>Neorg generate-workspace-summary<CR>", { desc = "Neorg summary" })
      vim.keymap.set("n", leader .. "t", "<cmd>Neorg toc<CR>", { desc = "Neorg ToC" })
    end,
  },
}
