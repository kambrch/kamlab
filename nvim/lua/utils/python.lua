local M = {}

local is_windows = vim.loop.os_uname().version:match "Windows" ~= nil

local function join_path(...)
  return table.concat({ ... }, is_windows and "\\" or "/")
end

local function trim(value)
  return (value or ""):gsub("^%s*(.-)%s*$", "%1")
end

local function get_venv_python(venv_path)
  if not venv_path or venv_path == "" then return nil end
  local python_path = is_windows and join_path(venv_path, "Scripts", "python.exe") or join_path(venv_path, "bin", "python")
  if vim.fn.executable(python_path) == 1 then return python_path end
  return nil
end

function M.find_root(start_path)
  local path = start_path and start_path ~= "" and start_path or vim.api.nvim_buf_get_name(0)
  local root = vim.fs.root(path, { "poetry.lock", "pyproject.toml", ".venv", "venv", "env", ".git" })
  return root or vim.fn.getcwd()
end

function M.poetry_python(root)
  if vim.fn.executable "poetry" ~= 1 then return nil end

  local result = vim.system({ "poetry", "env", "info", "--path" }, { cwd = root, text = true }):wait()
  if result.code ~= 0 then return nil end

  return get_venv_python(trim(result.stdout))
end

function M.resolve_python(root)
  local project_root = root or M.find_root()

  local poetry_path = M.poetry_python(project_root)
  if poetry_path then return poetry_path end

  local active_venv = get_venv_python(vim.env.VIRTUAL_ENV)
  if active_venv then return active_venv end

  for _, venv_dir in ipairs { ".venv", "venv", "env" } do
    local local_venv = get_venv_python(join_path(project_root, venv_dir))
    if local_venv then return local_venv end
  end

  return vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
end

return M
