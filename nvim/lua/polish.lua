-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

local python = require "utils.python"

-- Keep Python provider aligned with current project environment.
-- Only refresh for Python files to avoid slowdown on other filetypes.
local function refresh_python_host_prog(args)
  -- Skip if not a Python file
  local bufnr = args and args.buf or 0
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  if filetype ~= "python" then
    return
  end

  local buffer_name = args and args.buf and vim.api.nvim_buf_get_name(args.buf) or nil
  local root = python.find_root(buffer_name)
  local python_path = python.resolve_python(root)
  if python_path and python_path ~= "" then
    vim.g.python3_host_prog = python_path
  end
end

-- Only set up autocmds for Python files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "python",
  callback = refresh_python_host_prog,
  desc = "Refresh Python provider path for Python files",
})

-- Initial setup for Python files already open
if vim.bo.filetype == "python" then
  refresh_python_host_prog()
end

-- Enable spell checking for specific file types
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "markdown", "md", "tex", "latex", "plaintex", "rst", "asciidoc", "org", "mail" },
  callback = function()
    vim.opt_local.spell = true
    -- Check if Polish spell file is available, otherwise use only English
    local spell_dir = vim.fn.stdpath("data") .. "/site/spell"
    
    -- Ensure the spell directory exists before checking for Polish files
    local spell_dir_exists = vim.fn.isdirectory(spell_dir) == 1
    
    -- Check for both .spl (spell) and .sug (suggestions) files
    local pl_spell_available = false
    if spell_dir_exists then
      local spl_files = vim.fn.glob(spell_dir .. "/pl.*.spl", false, true) -- return as list
      local sug_files = vim.fn.glob(spell_dir .. "/pl.*.sug", false, true) -- return as list
      pl_spell_available = #spl_files > 0 or #sug_files > 0
    end

    if pl_spell_available then
      vim.opt_local.spelllang = { "en", "pl" }  -- English and Polish
    else
      vim.opt_local.spelllang = "en"  -- Only English if Polish is not available
      -- Notify user that Polish spell check is not available
      vim.notify_once("Polish spell check not available. Install Polish spell files to enable.", vim.log.levels.WARN, { title = "Spell Checker" })
    end
  end,
  desc = "Enable English and Polish spell checking for text files",
})
