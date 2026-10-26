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
-- The native server relies on the client to watch files, which nvim disables on Linux by default;
-- without it, changes made on disk outside nvim are never seen.
local tsc = vim.lsp.config.tsc
vim.lsp.config('tsc', {
  cmd = tsc.cmd,
  capabilities = {
    workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
  },
  root_dir = function(bufnr, on_dir)
    if is_native(find_typescript(bufnr)) then
      tsc.root_dir(bufnr, on_dir)
    end
  end,
})
vim.lsp.enable('tsc')

-- nvim ignores the server's interFileDependencies: a change in one file never re-pulls the diagnostics
-- of the files importing it. Re-pull them for the other visible buffers on every change,
-- and for a hidden buffer when it is shown again.
local function tsc_client_id(bufnr)
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = 'tsc' })[1]
  return client and client.id
end

vim.api.nvim_create_autocmd('LspNotify', {
  callback = function(event)
    local method = event.data.method
    if method ~= 'textDocument/didChange' and method ~= 'textDocument/didOpen' then
      return
    end
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client or client.name ~= 'tsc' then
      return
    end
    for bufnr in pairs(client.attached_buffers) do
      if bufnr ~= event.buf then
        vim.lsp.diagnostic._refresh(bufnr, client.id, true)
      end
    end
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function(event)
    local client_id = tsc_client_id(event.buf)
    if client_id then
      vim.lsp.diagnostic._refresh(event.buf, client_id)
    end
  end,
})

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
