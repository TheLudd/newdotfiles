require('neodev').setup({
  -- add any options here, or leave empty to use the default settings
})

local lspconfig = require('lspconfig')

local function buf_set_keymap(bufnr, ...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local function buf_set_option(bufnr, ...) vim.api.nvim_buf_set_option(bufnr, ...) end

-- example to setup lua_ls and enable call snippets
lspconfig.lua_ls.setup({ settings = { Lua = { completion = { callSnippet = 'Replace' } } } })

-- Mappings.
local opts = { noremap = true, silent = true }

-- function formatFilter(client) return client.name ~= 'tsserver' end

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'R', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<space>i', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  buf_set_keymap(bufnr, 'n', '<space>n', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
  buf_set_keymap(bufnr, 'n', '<space>N', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
  buf_set_keymap(bufnr, 'n', '<space>F', '<cmd>lua vim.lsp.buf.format()<cr>', opts)
end

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
