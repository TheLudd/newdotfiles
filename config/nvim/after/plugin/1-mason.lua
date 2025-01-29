local ok, lspconfig = pcall(require, "lspconfig")

if not ok then
  return
end

require('mason').setup()

local function buf_set_keymap(bufnr, ...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

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
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_json_ls_attach = function(client, bufnr)
  on_attach(client, bufnr)
  local has_biome = lspconfig.util.root_pattern("biome.json")(vim.api.nvim_buf_get_name(bufnr))
  if has_biome then
    client.server_capabilities.documentFormattingProvider = false
  end
  on_attach(client, bufnr)
end

local serverMappings = {
  terraformls = {
    on_attach = on_attach,
  },
  biome = {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "biome", "lsp-proxy" },
    filetypes = { "javascript", "typescript", "typescriptreact", "json", "toml", "markdown", "html", "css" },
    root_dir = lspconfig.util.root_pattern("biome.json"),
    single_file_support = false,
  },
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
    settings = {
      workingDirectory = { mode = 'auto' },
    },
  },
  jsonls = {
    on_attach = on_json_ls_attach,
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
  }
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
