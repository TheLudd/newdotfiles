local lspconfig = require('lspconfig')

CONFIG_HOME = vim.fn.expand('$XDG_CONFIG_HOME')

-- Mappings.
local opts = { noremap = true, silent = true }

local function buf_set_keymap(bufnr, ...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local function buf_set_option(bufnr, ...) vim.api.nvim_buf_set_option(bufnr, ...) end

function formatFilter(client) return client.name ~= 'tsserver' end

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<space>i', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  buf_set_keymap(bufnr, 'n', '<space>n', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
  buf_set_keymap(bufnr, 'n', '<space>N', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
  buf_set_keymap(bufnr, 'n', '<space>F', '<cmd>lua vim.lsp.buf.format({ filter = formatFilter })<cr>', opts)
end

-- Set up completion using nvim_cmp with LSP source
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.tsserver.setup {
  on_attach = on_attach,
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  capabilities = capabilities,
}

local prettier = { formatCommand = 'prettierd "${INPUT}"', formatStdin = true, env = { 'PRETTIERD_LOCAL_PRETTIER_ONLY=true' } }

lspconfig.efm.setup {
  on_attach = on_attach,
  init_options = { documentFormatting = true },
  filetypes = { 'lua', 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  settings = {
    rootMarkers = { '.git/' },
    languages = {
      lua = { { formatCommand = 'lua-format -i', formatStdin = true } },
      javascript = { prettier },
      javascriptreact = { prettier },
      typescript = { prettier },
      typescriptreact = { prettier },
    },
  },
}

lspconfig.eslint.setup {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>EslintFixAll<CR>', opts)
  end,
}

lspconfig.jsonls.setup({
  on_attach = on_attach,
  settings = {
    json = {
      -- Schemas https://www.schemastore.org
      schemas = {
        { fileMatch = { 'package.json' }, url = 'https://json.schemastore.org/package.json' },
        { fileMatch = { 'tsconfig*.json' }, url = 'https://json.schemastore.org/tsconfig.json' },
        { fileMatch = { '.prettierrc', '.prettierrc.json', 'prettier.config.json' }, url = 'https://json.schemastore.org/prettierrc.json' },
        { fileMatch = { '.eslintrc', '.eslintrc.json' }, url = 'https://json.schemastore.org/eslintrc.json' },
        { fileMatch = { 'lerna.json' }, url = 'https://json.schemastore.org/lerna.json' },

      },
    },
  },
  capabilities = capabilities,
})

lspconfig.vls.setup{}
vim.cmd([[au BufNewFile,BufRead *.v set filetype=vlang]])
