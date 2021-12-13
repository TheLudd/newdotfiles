local lspconfig = require('lspconfig')

CONFIG_HOME = vim.fn.expand('$XDG_CONFIG_HOME')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = {noremap=true, silent=true}

  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Set up completion using nvim_cmp with LSP source
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.tsserver.setup {on_attach=on_attach, filetypes={"typescript", "typescriptreact", "typescript.tsx"}, capabilities=capabilities}

lspconfig.efm.setup {
  init_options={documentFormatting=true},
  filetypes={"lua"},
  settings={
    rootMarkers={".git/"},
    languages={
      lua={
        {
          formatCommand="lua-format -i --no-keep-simple-function-one-line --no-break-after-operator --column-limit=150 --break-after-table-lb",
          formatStdin=true,
        },
      },
    },
  },
}

local sumneko_root_path = CONFIG_HOME .. "/nvim/lua-language-server"
local sumneko_binary = "lua-language-server"
lspconfig.sumneko_lua.setup {
  cmd={sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
  settings={
    Lua={
      runtime={
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version='LuaJIT',
        -- Setup your lua path
        path=vim.split(package.path, ';'),
      },
      diagnostics={
        -- Get the language server to recognize the `vim` global
        globals={'vim'},
      },
      workspace={
        -- Make the server aware of Neovim runtime files
        library={[vim.fn.expand('$VIMRUNTIME/lua')]=true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')]=true},
      },
    },
  },
}