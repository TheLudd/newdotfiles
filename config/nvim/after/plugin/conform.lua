require('conform').setup({
  keys = {
    {
      '<space>f',
      function()
        require('conform').format({ async = true, lsp_format = 'never' })
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    -- Conform will run the first available formatter
    javascript = { 'biome', 'biome-organize-imports', 'eslint_d' },
    javascriptreact = { 'biome', 'biome-organize-imports', 'eslint_d' },
    typescript = { 'biome', 'biome-organize-imports', 'eslint_d' },
    typescriptreact = { 'biome', 'biome-organize-imports', 'eslint_d' },
  },
  formatters = {
    stylua = {
      command = 'pnpx',
      args = {
        '@johnnymorganz/stylua-bin',
        '--stdin-filepath',
        '$FILENAME',
        '-',
        '--quote-style',
        'ForceSingle',
        '--indent-type',
        'Spaces',
        '--indent-width',
        '2',
      },
      stdin = true,
    },
  },
})
