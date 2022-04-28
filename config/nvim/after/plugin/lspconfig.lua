local lspconfig = require('lspconfig')

CONFIG_HOME = vim.fn.expand('$XDG_CONFIG_HOME')

-- Mappings.
local opts = { noremap = true, silent = true }

local function buf_set_keymap(bufnr, ...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local function buf_set_option(bufnr, ...) vim.api.nvim_buf_set_option(bufnr, ...) end

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<space>i', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  buf_set_keymap(bufnr, 'n', '<space>n', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
  buf_set_keymap(bufnr, 'n', '<space>N', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
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

lspconfig.eslint.setup {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>EslintFixAll<CR>', opts)
  end,
}
