-- Yanky-nvim configuration with system clipboard sync
---@type LazySpec
return {
  "gbprod/yanky.nvim",
  event = "TextYankPost",
  opts = function(_, opts)
    local astrocore = require "astrocore"
    opts = astrocore.extend_tbl(opts, {
      highlight = { timer = 200 },
      ring = { storage = "shada" }, -- Use shada for better portability
      clipboard = {
        register = "+", -- Use system clipboard register
      },
    })
    return opts
  end,
  config = function(_, opts)
    local yanky = require("yanky")
    yanky.setup(opts)

    -- Set up key mappings (from astrocommunity)
    local map = vim.keymap.set
    map("n", "y", yanky.yank, { silent = true, expr = true, desc = "Yank text" })
    map("x", "y", yanky.yank, { silent = true, expr = true, desc = "Yank text" })
    map("n", "p", function() yanky.put("p", false) end, { silent = true, desc = "Put yanked text after cursor" })
    map("n", "P", function() yanky.put("P", false) end, { silent = true, desc = "Put yanked text before cursor" })
    map("n", "gp", function() yanky.put("gp", false) end, { silent = true, desc = "Put yanked text after selection" })
    map("n", "gP", function() yanky.put("gP", false) end, { silent = true, desc = "Put yanked text before selection" })
    map("x", "p", function() yanky.put("p", true) end, { silent = true, desc = "Put yanked text after cursor" })
    map("x", "P", function() yanky.put("P", true) end, { silent = true, desc = "Put yanked text before cursor" })
    map("n", "[y", function() yanky.cycle(-1) end, { silent = true, desc = "Cycle backward through yank history" })
    map("n", "]y", function() yanky.cycle(1) end, { silent = true, desc = "Cycle forward through yank history" })
    map("n", "]p", function() yanky.put("]p", false) end, { silent = true, desc = "Put indented after cursor (linewise)" })
    map("n", "[p", function() yanky.put("[p", false) end, { silent = true, desc = "Put indented before cursor (linewise)" })
    -- Insert mode: paste from system clipboard
    map("i", "<C-V>", function() return '<C-R>+' end, { silent = true, expr = true, desc = "Paste from system clipboard" })

    local clipboard_augroup = vim.api.nvim_create_augroup("YankySystemClipboard", { clear = true })
    local external_clipboard_synced = false

    -- Sync every yank to system clipboard immediately
    vim.api.nvim_create_autocmd("TextYankPost", {
      group = clipboard_augroup,
      callback = function()
        external_clipboard_synced = false
        -- Copy the yanked content to the + (system clipboard) register
        if vim.v.event.operator == "y" then
          local reg = vim.v.event.regname
          -- Use register 0 for default register, otherwise use the specified register
          local regname = (reg == "" or reg == '"') and "0" or reg
          local content = vim.fn.getreg(regname)
          local regtype = vim.fn.getregtype(regname)
          vim.fn.setreg("+", content, regtype)
        end
      end,
    })

    -- Sync system clipboard to yanky history for external paste
    local function sync_external_clipboard()
      if external_clipboard_synced then
        return
      end
      local content = vim.fn.getreg("+")
      if content and content ~= "" then
        -- Check if content contains newlines - if so, it's linewise
        local regtype = vim.fn.getregtype("+")
        if not regtype or regtype == "" or regtype == "v" then
          if content:find("\n") then
            regtype = "V" -- linewise
          else
            regtype = "v" -- character-wise
          end
        end
        -- Push to yanky history as the most recent item
        yanky.history.push({
          regcontents = content,
          regtype = regtype,
          regname = "+",
          filetype = vim.bo.filetype,
        })
        external_clipboard_synced = true
      end
    end

    vim.api.nvim_create_autocmd({ "FocusGained", "InsertEnter" }, {
      group = clipboard_augroup,
      callback = sync_external_clipboard,
    })
  end,
}
