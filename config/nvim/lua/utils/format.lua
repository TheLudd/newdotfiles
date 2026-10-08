local M = {}

local biome_configs = { 'biome.json', 'biome.jsonc' }

-- The project's own biome when installed, so nvim matches the terminal.
M.biome_bin = function(root)
  local local_bin = root and root .. '/node_modules/.bin/biome'
  if local_bin and vim.fn.executable(local_bin) == 1 then
    return local_bin
  end
  return 'biome'
end

-- Replace only the changed lines, keeping marks and cursor in place.
local function apply_lines(bufnr, old_lines, new_lines)
  local old_text = table.concat(old_lines, '\n') .. '\n'
  local new_text = table.concat(new_lines, '\n') .. '\n'
  local hunks = vim.diff(old_text, new_text, { result_type = 'indices' })
  for i = #hunks, 1, -1 do
    local start_a, count_a, start_b, count_b = unpack(hunks[i])
    local first = count_a == 0 and start_a or start_a - 1
    local replacement = vim.list_slice(new_lines, start_b, start_b + count_b - 1)
    vim.api.nvim_buf_set_lines(bufnr, first, first + count_a, false, replacement)
  end
end

-- Run `biome check --write --unsafe` on the buffer: format, organize imports and apply all fixes.
local function biome_check(bufnr)
  local root = vim.fs.root(bufnr, biome_configs)
  local old_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local result = vim.system({
    M.biome_bin(root), 'check', '--write', '--unsafe',
    '--stdin-file-path=' .. vim.api.nvim_buf_get_name(bufnr),
  }, { cwd = root, stdin = table.concat(old_lines, '\n') .. '\n' }):wait()

  if result.code ~= 0 then
    vim.notify('biome check failed:\n' .. (result.stderr ~= '' and result.stderr or result.stdout), vim.log.levels.ERROR)
    return
  end

  local new_lines = vim.split(result.stdout, '\n', { plain = true })
  if new_lines[#new_lines] == '' then
    table.remove(new_lines)
  end
  apply_lines(bufnr, old_lines, new_lines)
end

local function attached(bufnr, name)
  return #vim.lsp.get_clients({ bufnr = bufnr, name = name }) > 0
end

-- Biome check when biome is attached, else eslint fixes, else any formatting client.
M.format = function()
  local bufnr = vim.api.nvim_get_current_buf()
  if attached(bufnr, 'biome') then
    biome_check(bufnr)
  elseif attached(bufnr, 'eslint') then
    vim.cmd('LspEslintFixAll')
  else
    vim.lsp.buf.format({ async = false })
  end
end

return M
