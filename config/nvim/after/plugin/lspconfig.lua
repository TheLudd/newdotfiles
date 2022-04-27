local lspconfig = require('lspconfig')

CONFIG_HOME = vim.fn.expand('$XDG_CONFIG_HOME')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }

  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Set up completion using nvim_cmp with LSP source
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.tsserver.setup {
  on_attach = on_attach,
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  capabilities = capabilities,
}

lspconfig.efm.setup {
  init_options = { documentFormatting = true },
  filetypes = { 'lua' },
  settings = { rootMarkers = { '.git/' }, languages = { lua = { { formatCommand = 'lua-format -i', formatStdin = true } } } },
}

lspconfig.eslint.setup {}
