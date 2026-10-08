local ok, mason = pcall(require, 'mason')

if not ok then
  return
end

vim.diagnostic.config({
  float = { border = 'rounded' },
})

-- Keymaps for every language server, including those started outside this file (typescript).
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local map = function(lhs, rhs) vim.keymap.set('n', lhs, rhs, { buffer = event.buf, silent = true }) end
    map('gd', vim.lsp.buf.definition)
    map('gD', function()
      vim.diagnostic.open_float()
      vim.diagnostic.open_float() -- the second call focuses the float
    end)
    map('K', vim.lsp.buf.hover)
    map('R', vim.lsp.buf.references)
    map('<space>r', function() require('utils.rename').rename() end)
    map('<space>i', vim.lsp.buf.code_action)
    map('<space>n', function() vim.diagnostic.jump({ count = 1, float = true }) end)
    map('<space>N', function() vim.diagnostic.jump({ count = -1, float = true }) end)
    map('<space>f', function() require('utils.format').format() end)
  end,
})

vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      completion = {
        callSnippet = 'Replace',
      },
    },
  },
})

vim.lsp.config('eslint', {
  settings = {
    workingDirectory = { mode = 'auto' },
  },
})

vim.lsp.config('hls', {
  filetypes = { 'haskell' },
})

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      cargo = { allFeatures = true },
      checkOnSave = { command = 'clippy' },
    },
  },
})

vim.lsp.config('jsonls', {
  settings = {
    json = {
      -- Schemas https://www.schemastore.org
      schemas = {
        { fileMatch = { 'package.json' },                                            url = 'https://json.schemastore.org/package.json' },
        { fileMatch = { 'tsconfig*.json' },                                          url = 'https://json.schemastore.org/tsconfig.json' },
        { fileMatch = { '.prettierrc', '.prettierrc.json', 'prettier.config.json' }, url = 'https://json.schemastore.org/prettierrc.json' },
        { fileMatch = { '.eslintrc', '.eslintrc.json' },                             url = 'https://json.schemastore.org/eslintrc.json' },
        { fileMatch = { 'lerna.json' },                                              url = 'https://json.schemastore.org/lerna.json' },
      },
    },
  },
})

-- Not enabled; enable with vim.lsp.enable('amend_lsp').
vim.lsp.config('amend_lsp', {
  cmd = { 'amend-lsp', '--stdio' },
  filetypes = { 'javascript', 'typescript' },
  root_markers = { 'package.json', 'tsconfig.json', '.git' },
})

-- Installed by mason and enabled; typescript servers are set up in tsserver.lua.
local servers = { 'biome', 'eslint', 'hls', 'jsonls', 'lua_ls', 'rust_analyzer', 'terraformls' }

mason.setup()
require('mason-lspconfig').setup({
  ensure_installed = servers,
  automatic_enable = servers,
})
