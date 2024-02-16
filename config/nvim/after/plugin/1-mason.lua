require('mason').setup()

local function buf_set_keymap(bufnr, ...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local function buf_set_option(bufnr, ...) vim.api.nvim_buf_set_option(bufnr, ...) end

-- Mappings.
local opts = { noremap = true, silent = true }

local on_attach = function(_, bufnr)
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

local serverMappings = {
  efm = {
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
  },
  eslint = {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>EslintFixAll<CR>', opts)
    end,
  },
}

require('mason-lspconfig').setup({ ensure_installed = serverMappings })

require('mason-lspconfig').setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    local config = serverMappings[server_name] or {}
    require('lspconfig')[server_name].setup(config)
  end,
}
