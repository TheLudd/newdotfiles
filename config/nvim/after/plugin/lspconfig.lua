local lspconfig = vim.lsp.config

if not ok then
  return
end

-- example to setup lua_ls and enable call snippets
lspconfig.lua_ls.setup({ settings = { Lua = { completion = { callSnippet = 'Replace' } } } })

require('lspconfig.configs').amendLsp = {
  default_config = {
    cmd = { 'amend-lsp', '--stdio' },
    filetypes = { 'javascript', 'typescript' },
    root_dir = function(fname)
      return require('lspconfig.util').root_pattern('package.json', 'tsconfig.json', '.git')(fname) or vim.fn.getcwd()
    end,
    settings = {},
  },
}

lspconfig.amendLsp.setup {}
