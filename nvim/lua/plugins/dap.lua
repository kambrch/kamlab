-- DAP (Debug Adapter Protocol) configuration with manual keybind activation
-- DAP is lazy-loaded and only activated via keybindings
---@type LazySpec
return {
  -- Main DAP plugin - lazy loaded
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      -- DAP keybindings (only load DAP when these are used)
      { "<Leader>d", desc = "+debug" },
      { "<Leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<Leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional Breakpoint" },
      { "<Leader>dc", function() require("dap").continue() end, desc = "Continue Debugging" },
      { "<Leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<Leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<Leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<Leader>dr", function() require("dap").restart() end, desc = "Restart" },
      { "<Leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<Leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<Leader>de", function() require("dapui").eval() end, desc = "Evaluate Expression", mode = { "n", "v" } },
      { "<Leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    },
    config = function()
      local dap = require "dap"
      local dap_ui = require "dapui"

      -- DAP UI configuration
      dap_ui.setup {
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        element_order = { "breakpoints", "scopes", "stacks", "watches" },
        controls = {
          element = "repl",
          enabled = true,
          icons = { pause = "⏸", play = "▶", step_into = "⏎", step_over = "⏭", step_out = "⏮", step_back = "b", run_last = "↻", terminate = "⏹" },
        },
      }

      -- Auto-open DAP UI on debug start
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dap_ui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dap_ui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dap_ui.close()
      end

      -- Python debugger configuration (lazy setup)
      local function setup_python_dap()
        local dap_python = require "dap-python"
        local python_path = vim.fn.exepath "python3"
        if python_path == "" then
          python_path = vim.fn.exepath "python"
        end
        if python_path ~= "" then
          dap_python.setup(python_path)
        end
      end

      -- Setup Python DAP when needed
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          -- Only setup if DAP is loaded
          if package.loaded["dap"] then
            setup_python_dap()
          end
        end,
      })

      -- Virtual text configuration (plugin may be unavailable during partial sync)
      local ok_virtual_text, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
      if ok_virtual_text then
        dap_virtual_text.setup {
          enabled = true,
          enabled_commands = true,
          all_frames = false,
          virt_text_pos = "eol",
        }
      end
    end,
  },

  -- Mason DAP integration - lazy loaded
  {
    "jay-babu/mason-nvim-dap.nvim",
    lazy = true,
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = { "debugpy" },
      automatic_installation = false,
      handlers = {},
    },
  },

  -- DAP completion - lazy loaded
  {
    "rcarriga/cmp-dap",
    lazy = true,
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      -- Only register if cmp is available
      if pcall(require, "cmp") then
        require("cmp").setup.filetype({ "dap-repl", "dapui.watches", "dapui.hover" }, {
          sources = {
            { name = "dap" },
          },
        })
      end
    end,
  },
}
