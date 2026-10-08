local border = "rounded"

local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover({ border = "rounded" })<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'R', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>r', '<cmd>lua require("utils.rename").rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>i', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>n', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>N', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua require("utils.format").format()<cr>', opts)
end

-- The project's own typescript, found like typescript-tools does: the nearest node_modules/typescript.
local function find_typescript(bufnr)
  for root in vim.fs.parents(vim.api.nvim_buf_get_name(bufnr)) do
    local package_json = root .. '/node_modules/typescript/package.json'
    if vim.fn.filereadable(package_json) == 1 then
      local ok, pkg = pcall(vim.json.decode, table.concat(vim.fn.readfile(package_json), '\n'))
      local major = ok and tonumber((pkg.version or ''):match('^(%d+)')) or nil
      return { root = root, major = major }
    end
  end
  return nil
end

-- TypeScript 7 is the native port: it ships an LSP server instead of tsserver.js.
local function is_native(typescript)
  return typescript ~= nil and typescript.major ~= nil and typescript.major >= 7
end

vim.lsp.config('tsgo', {
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({ config.root_dir .. '/node_modules/.bin/tsc', '--lsp', '--stdio' }, dispatchers,
      { cwd = config.root_dir })
  end,
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_dir = function(bufnr, on_dir)
    local typescript = find_typescript(bufnr)
    if is_native(typescript) then
      on_dir(typescript.root)
    end
  end,
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
})
vim.lsp.enable('tsgo')

local ok, typescriptTools = pcall(require, 'typescript-tools')

if not ok then
  return
end

local typescript_tools_util = require('typescript-tools.utils')

typescriptTools.setup {
  on_attach = on_attach,
  root_dir = function(bufnr, on_dir)
    if not is_native(find_typescript(bufnr)) then
      on_dir(typescript_tools_util.get_root_dir(bufnr))
    end
  end,
  settings = {
    tsserver_file_preferences = { quotePreference = 'single' }
  },
  handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
  },
}
