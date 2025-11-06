local lspconfig = vim.lsp.config

if not ok then
  return
end

require('mason').setup()

local function buf_set_keymap(bufnr, ...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

-- Mappings.
local opts = { noremap = true, silent = true }

local on_attach = function(_, bufnr)
  buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.diagnostic.open_float()<CR><Cmd>lua vim.diagnostic.open_float()<CR>',
    opts)

  buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'R', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<space>i', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  buf_set_keymap(bufnr, 'n', '<space>n', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
  buf_set_keymap(bufnr, 'n', '<space>N', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
  buf_set_keymap(bufnr, 'n', '<space>F', '<cmd>lua vim.lsp.buf.format({ async = false })', opts)

  buf_set_keymap(bufnr, 'n', '<space>w', '', {
    noremap = true,
    silent = true,
    callback = function()
      local util = require("lspconfig.util")
      local cwd = util.root_pattern("biome.json", "biome.jsonc")(vim.fn.expand("%:p"))
      local file = vim.api.nvim_buf_get_name(0)

      vim.fn.jobstart({ "biome", "check", "--write", file }, {
        cwd = cwd or vim.fn.getcwd(),
        on_exit = function(_, code)
          if code == 0 then
            vim.schedule(function()
              vim.cmd("edit!")
            end)
          else
          end
        end,
      })
    end,
    desc = "Format and organize imports via Biome",
  })
end

local prettier = { formatCommand = 'prettierd "${INPUT}"', formatStdin = true, env = { 'PRETTIERD_LOCAL_PRETTIER_ONLY=true' } }
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local uv = vim.uv or vim.loop

local function project_has_biome(root_dir)
  local paths = { "biome.json", "biome.jsonc" }
  for _, file in ipairs(paths) do
    local full_path = table.concat({ root_dir, file }, "/")
    if uv.fs_stat(full_path) then
      return true
    end
  end
  return false
end

local function on_attach_with_biome_check(client, bufnr)
  local root_dir = client.config.root_dir or vim.fn.getcwd()
  if project_has_biome(root_dir) and client.name ~= "biome" then
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
    root_dir = lspconfig.util.root_pattern("biome.json", "biome.jsonc"),
    single_file_support = false,

  },
  efm = {
    on_attach = on_attach_with_biome_check,
    init_options = { documentFormatting = true },
    filetypes = { 'lua', 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    root_dir = lspconfig.util.root_pattern(".prettierrc.yaml"),
    settings = {
      rootMarkers = { '.prettierrc.yaml' },
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
  hls = {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "haskell" },
    root_dir = lspconfig.util.root_pattern("stack.yaml", "cabal.project", "package.yaml"),
  },
  rust_analyzer = {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_dir = lspconfig.util.root_pattern("Cargo.toml", "rust-project.json"),
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = { command = "clippy" },
      },
    },
  },
  jsonls = {
    on_attach = on_attach_with_biome_check,
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
