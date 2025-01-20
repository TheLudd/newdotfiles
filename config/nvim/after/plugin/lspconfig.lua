local ok, lspconfig = pcall(require, 'lspconfig')

if not ok then
  return
end

-- example to setup lua_ls and enable call snippets
lspconfig.lua_ls.setup({ settings = { Lua = { completion = { callSnippet = 'Replace' } } } })
