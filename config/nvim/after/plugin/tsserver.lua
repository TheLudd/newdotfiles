-- The project's own typescript, found like typescript-tools does: the nearest node_modules/typescript.
local function find_typescript(bufnr)
  for root in vim.fs.parents(vim.api.nvim_buf_get_name(bufnr)) do
    local package_json = root .. '/node_modules/typescript/package.json'
    if vim.fn.filereadable(package_json) == 1 then
      local ok, pkg = pcall(vim.json.decode, table.concat(vim.fn.readfile(package_json), '\n'))
      local major = ok and tonumber((pkg.version or ''):match('^(%d+)')) or nil
      return { root = root, major = major }
    end
  end
  return nil
end

-- TypeScript 7 is the native port: it ships an LSP server instead of tsserver.js.
local function is_native(typescript)
  return typescript ~= nil and typescript.major ~= nil and typescript.major >= 7
end

-- TypeScript 7+: lspconfig's tsc server, which runs the project's `tsc --lsp`.
-- cmd and root_dir share a binary cache, so both must come from the same loaded config.
local tsc = vim.lsp.config.tsc
vim.lsp.config('tsc', {
  cmd = tsc.cmd,
  root_dir = function(bufnr, on_dir)
    if is_native(find_typescript(bufnr)) then
      tsc.root_dir(bufnr, on_dir)
    end
  end,
})
vim.lsp.enable('tsc')

-- Older TypeScript: typescript-tools, which talks to tsserver.js.
local ok, typescriptTools = pcall(require, 'typescript-tools')

if not ok then
  return
end

local typescript_tools_util = require('typescript-tools.utils')

typescriptTools.setup {
  root_dir = function(bufnr, on_dir)
    if not is_native(find_typescript(bufnr)) then
      on_dir(typescript_tools_util.get_root_dir(bufnr))
    end
  end,
  settings = {
    tsserver_file_preferences = { quotePreference = 'single' }
  },
}
